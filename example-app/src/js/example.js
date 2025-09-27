import { InAppBrowser } from 'wowguagua-inappbrower';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    InAppBrowser.echo({ value: inputValue })
}
