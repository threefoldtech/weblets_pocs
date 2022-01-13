/// <reference types="svelte" />

import * as rmb from 'ts-rmb-http-client';

interface I$libs {
  ts_rmb_http_client: typeof rmb;
}

declare global {
  interface Window {
    $libs: I$libs;
  }
}