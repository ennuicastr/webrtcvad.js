if (typeof process === "undefined" && typeof WebRtcVadWasm !== "undefined") {
    Module.locateFile = function (path, scriptDirectory) {
        if (/\.wasm$/.test(path))
            return WebRtcVadWasm;
        else
            return scriptDirectory + path;
    };
}
