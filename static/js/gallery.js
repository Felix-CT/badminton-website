(function () {
  function groupGalleryImages(gallery) {
    var images = Array.prototype.slice.call(gallery.querySelectorAll('img'));
    if (!images.length) return;

    var portraits = [];
    var landscapes = [];
    var squares = [];
    var pending = images.length;

    function finalize() {
      pending -= 1;
      if (pending > 0) return;
    }

    images.forEach(function (img) {
      function classify() {
        var w = img.naturalWidth || img.width;
        var h = img.naturalHeight || img.height;

        if (w && h) {
          if (h > w) {
            img.classList.add('is-portrait');
            portraits.push(img);
          } else if (w > h) {
            img.classList.add('is-landscape');
            landscapes.push(img);
          } else {
            img.classList.add('is-square');
            squares.push(img);
          }
        } else {
          squares.push(img);
        }

        finalize();
      }

      if (img.complete) {
        classify();
      } else {
        img.addEventListener('load', classify, { once: true });
        img.addEventListener('error', finalize, { once: true });
      }
    });
  }

  document.addEventListener('DOMContentLoaded', function () {
    var galleries = document.querySelectorAll('.gallery');
    galleries.forEach(function (gallery) {
      groupGalleryImages(gallery);
    });
  });
})();
