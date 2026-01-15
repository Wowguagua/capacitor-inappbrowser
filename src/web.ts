import { WebPlugin } from '@capacitor/core';

import type { InAppBrowserPlugin, OpenInAppBrowserOptions } from './definitions';

export class InAppBrowserWeb extends WebPlugin implements InAppBrowserPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }

  async openInAppBrowser(options: OpenInAppBrowserOptions): Promise<void> {
    console.log('OPEN IN APP BROWSER', options);
    return;
  }
}
