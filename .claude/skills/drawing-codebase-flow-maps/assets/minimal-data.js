/* The smallest valid map data file. The system is invented: a thumbnail service. Copy this file, then replace each value with facts of the real system. */

/* The page header, the legend and the controls read these values. */
const META = {
  title: 'Thumbnail Flow Map',
  repo: 'thumbnailer · main',
  facts: [['Stack', 'Go 1.24 · PostgreSQL 17']],
  snapshot: 'test fixtures',
  trace: 'one uploaded image',
};

/* Packets. Each one is the content of one dot. Use real rows. These rows are from test fixtures of the invented system. */
const PK = {
  upload: { title: 'Upload request', table: 'POST /images',
    src: 'internal/api/upload.go parses the multipart request.',
    data: { filename: 'harbour.jpg', content_type: 'image/jpeg', bytes: 2481133 } },
  job: { title: 'Job row', table: 'jobs',
    src: 'internal/api/upload.go writes one jobs row for each stored original.',
    data: { id: 4411, image_id: 'img_8f2c', state: 'queued', attempt: 0, sizes: [320, 1280] } },
  thumb: { title: 'Thumbnail object', table: 'objects',
    src: 'internal/resize/store.go writes one objects row for each size.',
    data: { image_id: 'img_8f2c', width: 320, key: 'thumbs/img_8f2c/320.webp', bytes: 18244, sha256: '9b1d…e07a' } },
};

/* The sections of the block list, in order. */
const GROUPS = [['pipe', 'The pipeline'], ['sup', 'Supporting the pipeline'], ['out', 'Outside the service']];

/* Blocks. x and y are the back corner of the footprint. See references/layout-and-routing.md. */
const NODES = [
  { id: 'page', name: 'Upload page', g: 'pipe', kind: 'ui', x: 0.5, y: 4, w: 3, d: 3, h: 0.4,
    does: ['The upload page lets a person select one image and send it.'],
    built: ['The page is one static HTML file. It sends a multipart POST request to <code>/images</code>.'],
    files: ['web/upload.html'] },
  { id: 'api', name: 'Upload API', g: 'pipe', kind: 'stage', x: 6, y: 3, w: 4, d: 4, h: 1.4, proc: 'api', pk: 'upload',
    does: ['The upload API stores the original image and queues one resize job.', 'The API answers before the resize starts. The answer contains the image ID.'],
    built: ['The handler is <code>POST /images</code>. The maximum size of one image is 20 MiB.', 'One transaction writes the <code>images</code> row and the <code>jobs</code> row.'],
    files: ['internal/api/upload.go', 'internal/api/limits.go'] },
  { id: 'resize', name: 'Resize worker', g: 'pipe', kind: 'stage', x: 14, y: 3, w: 4, d: 4, h: 1.4, proc: 'worker', pk: 'job',
    does: ['The resize worker makes one thumbnail for each requested width.', 'The worker reads the original image from the bucket and writes each thumbnail to the bucket.'],
    built: ['The worker claims one job at a time. A lease has a duration of 30 seconds.', 'The output format is WebP. The widths are 320 and 1280 pixels.'],
    files: ['internal/resize/worker.go', 'internal/resize/store.go'] },
  { id: 'bucket', name: 'Image bucket', g: 'pipe', kind: 'store', x: 22, y: 3, w: 4, d: 4, h: 1.26, pk: 'thumb',
    does: ['The image bucket holds each original image and each thumbnail.'],
    built: ['The key of a thumbnail is <code>thumbs/{image_id}/{width}.webp</code>.'],
    files: ['internal/storage/bucket.go'] },
  { id: 'cdn', name: 'CDN', g: 'out', kind: 'external', x: 30, y: 3, w: 4, d: 4, h: 0.6,
    does: ['The CDN serves the thumbnails to browsers. A different party operates it.'],
    built: ['The CDN reads the bucket through a read-only key.'],
    files: ['deploy/cdn.tf'] },
  { id: 'jobs', name: 'Job queue', g: 'sup', kind: 'queue', x: 9, y: 11.5, w: 6, d: 4.5, h: 1.2, pk: 'job',
    does: ['The job queue is one PostgreSQL table. The resize worker claims its work from this table.'],
    built: ['A claim uses <code>SKIP LOCKED</code>. A job has a maximum of 3 attempts.'],
    files: ['internal/queue/queue.go'] },
];

/* The steps inside each block, in execution order. `d` says what the step does. `why` says why it exists. Outside blocks have no steps. */
const STEPS = {
  page: [
    { n: 'Select', f: 'web/upload.html',
      d: 'The person selects one image file. The page refuses a file that is not an image.',
      why: 'The person sees the error before the upload starts.' },
    { n: 'Send', pk: 'upload', f: 'web/upload.html',
      d: 'The page sends the file in a multipart POST request to <code>/images</code>.',
      why: 'The API accepts only this request format.' },
  ],
  api: [
    { n: 'Parse', pk: 'upload', f: 'internal/api/upload.go',
      d: 'This step reads the request into a typed upload: a filename, a content type and a byte stream. It refuses a request of more than 20 MiB.',
      why: 'Each later step assumes a correct upload. Only this step reads the raw request.' },
    { n: 'Store original', pk: 'upload', f: 'internal/storage/bucket.go',
      d: 'This step sends the bytes to the bucket and calculates their SHA-256 during the transfer.',
      why: 'The worker reads the original from the bucket. Thus the API and the worker share no disk.' },
    { n: 'Queue job', pk: 'job', f: 'internal/api/upload.go',
      d: 'One transaction writes the <code>images</code> row and one <code>jobs</code> row with the state <code>queued</code>.',
      why: 'If the transaction fails, there is no image with no job and no job with no image.' },
  ],
  resize: [
    { n: 'Claim', pk: 'job', f: 'internal/queue/queue.go',
      d: 'The worker claims one queued job with <code>SKIP LOCKED</code> and sets a lease of 30 seconds.',
      why: 'Two workers cannot resize the same image at the same time.' },
    { n: 'Decode', pk: 'job', f: 'internal/resize/worker.go',
      d: 'This step reads the original image from the bucket and decodes it. It refuses an image of more than 100 megapixels.',
      why: 'An image of that size can use all the memory of the worker.' },
    { n: 'Write thumbnails', pk: 'thumb', f: 'internal/resize/store.go',
      d: 'This step makes one WebP thumbnail for each width and writes each one to the bucket. Then it writes one <code>objects</code> row for each thumbnail.',
      why: 'The CDN finds a thumbnail through its key. The row records that the thumbnail exists.' },
  ],
  bucket: [
    { n: 'Put', pk: 'thumb', f: 'internal/storage/bucket.go',
      d: 'This step writes one object with its content type and its SHA-256 as metadata.',
      why: 'A reader can compare the bytes with the SHA-256 and find a damaged object.' },
    { n: 'Get', pk: 'thumb', f: 'internal/storage/bucket.go',
      d: 'This step returns the bytes of one object as a stream.',
      why: 'The service does not hold a full image in memory.' },
  ],
  jobs: [
    { n: 'Queue', pk: 'job', f: 'internal/queue/queue.go',
      d: 'The API adds one job row with the state <code>queued</code>.',
      why: 'The API can answer before the resize starts.' },
    { n: 'Claim', pk: 'job', f: 'internal/queue/queue.go',
      d: 'One statement with <code>SKIP LOCKED</code> selects a queued row and sets its lease owner.',
      why: 'Many workers read one table and do not claim one row two times.' },
    { n: 'Complete', pk: 'job', f: 'internal/queue/queue.go',
      d: 'The worker sets the state to <code>done</code>. After a failure, it sets the state to <code>queued</code> again, for a maximum of 3 attempts.',
      why: 'A job that fails each time must stop. If not, it uses a worker without an end.' },
  ],
};

/* Lines. One line for each connection. `path` goes from the edge of block `a` to the edge of block `b`. */
const FLOWS = [
  { id: 'f_upload', what: 'The upload page sends one image to the upload API.', a: 'page', b: 'api', pk: 'upload', path: [[3.5, 6.4], [6, 6.4]] },
  { id: 'f_queue', what: 'The upload API adds one job to the job queue.', a: 'api', b: 'jobs', pk: 'job', path: [[9.5, 7], [9.5, 11.5]] },
  { id: 'f_claim', what: 'The resize worker claims one job from the job queue.', a: 'jobs', b: 'resize', pk: 'job', path: [[14.5, 11.5], [14.5, 7]] },
  { id: 'f_thumb', what: 'The resize worker writes each thumbnail to the image bucket.', a: 'resize', b: 'bucket', pk: 'thumb', path: [[18, 6.3], [22, 6.3]] },
  { id: 'f_serve', what: 'The CDN reads a thumbnail from the image bucket. It does this only for a thumbnail that is not in its cache.', a: 'bucket', b: 'cdn', dash: 1, path: [[26, 6.3], [30, 6.3]] },
];

/* The dots of the main subject, in the order of the data flow. */
const TRACE = ['f_upload', 'f_queue', 'f_claim', 'f_thumb'];

/* Process floors. `label` is the process name and the `proc` of each block inside. */
const ZONES = [
  { x0: 5.3, y0: 2.3, x1: 10.7, y1: 7.7, label: 'api' },
  { x0: 13.3, y0: 2.3, x1: 18.7, y1: 7.7, label: 'worker', lx: 16.2 },   // lx moves the label away from the line at x = 14.5
];

/* The first panel. The page adds the legend and the controls. */
const OVERVIEW = {
  title: 'Thumbnail service',
  pipeline: [
    'The upload page sends one image to the upload API.',
    'The upload API stores the original image and queues one job.',
    'The resize worker makes the thumbnails and writes them to the image bucket.',
  ],
  built: `
  <h2>Structure</h2>
  <p>The service has two processes: <code>api</code> and <code>worker</code>. PostgreSQL holds the job queue and the image records.</p>
  <h2>Related documents</h2>
  <ul><li><code>README.md</code></li></ul>`,
};
