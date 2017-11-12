function mpd_add(elem) {
  $.ajax({
    url: 'http://localhost:4000/api/mpd/add',
    method: 'post',
    data: {"query":elem.id}
  });
  UIkit.notification({message: "Add \"" + elem.innerHTML + "\""})
}
