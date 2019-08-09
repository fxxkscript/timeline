//var js = document.createElement('script');
//
//js.setAttribute('src', 'https://img.ippapp.com/hello.js?t=' + Date.now());
//
//document.head.appendChild(js);


(function(win, doc) {
console.log(1111);
  if (doc.getElementsByTagName('video').length <= 0) {
    return;
  }
  var link = doc.location.href;

  var div = doc.createElement('div');
  div.innerHTML = '<a target="_blank" href="https://api.isoyu.com/ckplayer/?url=' + link + '">绾胯矾涓€</a>';
  div.style = 'position: fixed; width: 100%; height: 50px; padding: 0 20px; border-top: 1px solid #ccc; line-height: 50px; left: 0;bottom: 0;background-color: #fff;';

  doc.body.appendChild(div);
})(window, window.document);