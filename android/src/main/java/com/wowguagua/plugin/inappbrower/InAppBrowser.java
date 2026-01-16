package com.wowguagua.plugin.inappbrower;

import android.content.Context;
import android.content.Intent;
import com.getcapacitor.Logger;
import com.getcapacitor.PluginConfig;

public class InAppBrowser {

    public String echo(String value) {
        Logger.info("Echo", value);
        return value;
    }

    public void openInAppBrowser(Context context, PluginConfig config, String url, String title) {
        Logger.info("openInAppBrowserLog", url);
        if (context == null || url == null || url.trim().isEmpty()) {
            Logger.warn("openInAppBrowser", "Missing context or url");
            return;
        }
        String headerTextColor = config.getString("headerTextColor","#242828");
        String progressBarColor = config.getString("progressBarColor","#007AFF");

        Intent intent = new Intent(context, InAppBrowserActivity.class);
        intent.putExtra(InAppBrowserActivity.EXTRA_URL, url);
        intent.putExtra(InAppBrowserActivity.EXTRA_TITLE, title);
        intent.putExtra(InAppBrowserActivity.EXTRA_HEADER_TEXT_COLOR, headerTextColor);
        intent.putExtra(InAppBrowserActivity.EXTRA_PROGRESS_BAR_COLOR, progressBarColor);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }
}
