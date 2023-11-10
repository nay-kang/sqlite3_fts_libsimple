'use strict';
(function(){
    let sqlite3Js = 'sqlite3.js';
    const urlParams = new URL(self.location.href).searchParams;
    if(urlParams.has('sqlite3.dir')){
      sqlite3Js = urlParams.get('sqlite3.dir') + '/' + sqlite3Js;
    }
    importScripts(sqlite3Js);
    let sqlitePromise = self.sqlite3InitModule({
        print: console.log,
        printErr: console.log
    });
    let sqliteInstance;
    let dbInstance;
    self.onmessage = async (e) => {
        let [method,args] = e.data;
        if(method==undefined){
            console.error('method undefined');
            return;
        }
        let rtn = null;
        switch(method){
            case 'init':
                if(sqliteInstance==undefined){
                    sqliteInstance = await sqlitePromise;
                }
                if(dbInstance==undefined){
                    const oo = sqliteInstance.oo1;
                    let constructor;
                    if(oo.OpfsDb){
                        constructor = oo.OpfsDb;
                    }else{//this is for development only
                        constructor = oo.DB;
                        console.log('sqlite run in development mode');
                    }
                    dbInstance = new constructor(...args);
                }
                break;
            case 'exec':
                try{
                    let [sql,bind] = args;
                    rtn = []
                    dbInstance.exec({
                        sql: sql,
                        bind: bind,
                        rowMode: 'object',
                        resultRows: rtn
                    })
                }catch(e){
                    console.error(e);
                }
                
        }
        self.postMessage(rtn);
    }
})();