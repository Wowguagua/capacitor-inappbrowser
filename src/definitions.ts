export interface InAppBrowserPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  openInAppBrowser(options: OpenInAppBrowserOptions): Promise<void>;
}

export interface OpenInAppBrowserOptions {
  url: string;
  title?: string;
}