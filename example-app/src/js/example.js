import { InAppBrowser } from 'wowguagua-inappbrower';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    InAppBrowser.echo({ value: inputValue }) 
    InAppBrowser.openInAppBrowser({ url: 'https://www.google.com', title:'Google網站' })    
}
