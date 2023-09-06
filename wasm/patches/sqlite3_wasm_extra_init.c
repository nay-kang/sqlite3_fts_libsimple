#include "sqlite3ext.h"
#include "sqlite3_wasm_extra_init.h"

SQLITE_EXTENSION_INIT1

int sqlite3_wasm_extra_init(const char *z){
  int rc = SQLITE_OK;
  rc = sqlite3_auto_extension((void (*)(void))sqlite3_simple_init);
  return rc;
}
