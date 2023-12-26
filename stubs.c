#include <emscripten.h>
#include <stdlib.h>

EM_JS(void, rtc_FatalMessageJS, (
    const char *file, int line, const char *msg
), {
    console.error(UTF8ToString(file) + ":" + line + ": " + UTF8ToString(msg));
});

void rtc_FatalMessage(const char *file, int line, const char *msg) {
    rtc_FatalMessageJS(file, line, msg);
    exit(1);
}
