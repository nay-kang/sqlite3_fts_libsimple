(function() {
  /*
  this script and the sqlite3.js is load by dart html package.
  so it is almost the latest loaded package.
  and the defer will not work here,because the html already finished load then dart excute and load this script
  */

  function initSqlite(){
    window.sqlite3InitModule({
      print: console,
      printErr: console,
    }).then(function (sqlite3) {
      console.log('sqlite3 inited in browser', sqlite3)
      sqliteInited(sqlite3)
    });
  }
  let counter=0;
  const interval = setInterval(function(){
    if(window.sqlite3InitModule){
      initSqlite();
      clearInterval(interval);
    }else if(counter>20){
      clearInterval(interval);
      throw new Error('failed to init sqlite');
    }
    console.log('wait for sqlite.js loading')
    counter++;
  },500);
  
})();