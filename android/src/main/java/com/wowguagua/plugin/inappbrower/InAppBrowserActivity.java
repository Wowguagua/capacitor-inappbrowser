package com.wowguagua.plugin.inappbrower;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageButton;
import android.widget.TextView;

public class InAppBrowserActivity extends Activity {
    public static final String EXTRA_URL = "InAppBrowserUrl";
    public static final String EXTRA_TITLE = "InAppBrowserTitle";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_in_app_browser);
        overridePendingTransition(R.anim.slide_in_up, 0);

        String url = getIntent().getStringExtra(EXTRA_URL);
        if (url == null || url.trim().isEmpty()) {
            finish();
            return;
        }

        View headerContainer = findViewById(R.id.in_app_browser_header_container);
        TextView header = findViewById(R.id.in_app_browser_header);
        WebView webView = findViewById(R.id.in_app_browser_webview);
        ImageButton backButton = findViewById(R.id.in_app_browser_back);
        View closeButton = findViewById(R.id.in_app_browser_close);

        Uri uri = Uri.parse(url);
        String host = uri.getHost();
        
        String title = getIntent().getStringExtra(EXTRA_TITLE);
        header.setText(title != null ? title : host != null ? host : "In-App Browser");

        backButton.setOnClickListener(v -> {
            if (webView.canGoBack()) {
                webView.goBack();
            }
        });
        closeButton.setOnClickListener(v -> finish());

        int headerBaseTopPadding = headerContainer.getPaddingTop();
        int headerBaseHeight = headerContainer.getLayoutParams().height;
        headerContainer.setOnApplyWindowInsetsListener((v, insets) -> {
            int topInset = insets.getSystemWindowInsetTop();
            v.setPadding(v.getPaddingLeft(), headerBaseTopPadding + topInset, v.getPaddingRight(), v.getPaddingBottom());
            if (headerBaseHeight > 0) {
                v.getLayoutParams().height = headerBaseHeight + topInset;
                v.requestLayout();
            }
            return insets;
        });
        headerContainer.requestApplyInsets();

        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public void onPageFinished(WebView view, String url) {
                updateBackButtonVisibility(view, backButton);
            }
        });
        updateBackButtonVisibility(webView, backButton);
        webView.loadUrl(url);
    }

    @Override
    public void finish() {
        super.finish();
        overridePendingTransition(0, R.anim.slide_out_down);
    }

    private void updateBackButtonVisibility(WebView webView, View backButton) {
        backButton.setVisibility(webView.canGoBack() ? View.VISIBLE : View.GONE);
    }
}
