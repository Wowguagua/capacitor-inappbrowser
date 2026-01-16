/// <reference types="@capacitor/cli" />

declare module '@capacitor/cli' {
  export interface PluginsConfig {
    InAppBrowser: {
      /**
       * The color of the progress bar.
       * @default "#007AFF"
       * @example "#FF9900"
       */
      progressBarColor?: string;
      /**
       * The color of the header text and icons.
       * @default #242828
       * @example "#FF9900"
       */
      headerTextColor?: string;
    };
  }
}

export interface InAppBrowserPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  openInAppBrowser(options: OpenInAppBrowserOptions): Promise<void>;
}

export interface OpenInAppBrowserOptions {
  url: string;
  title?: string;
}