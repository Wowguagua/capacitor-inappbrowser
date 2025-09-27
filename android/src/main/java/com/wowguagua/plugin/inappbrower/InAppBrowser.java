package com.wowguagua.plugin.inappbrower;

import com.getcapacitor.Logger;

public class InAppBrowser {

    public String echo(String value) {
        Logger.info("Echo", value);
        return value;
    }
}
