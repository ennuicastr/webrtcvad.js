if ((function() {
    try {
        var module = new WebAssembly.Module(new Uint8Array([
            0x0, 0x61, 0x73, 0x6d, 0x1, 0x0, 0x0, 0x0
        ]));
        if (module instanceof WebAssembly.Module) {
            return new WebAssembly.Instance(module) instanceof
                WebAssembly.Instance;
        }
    } catch (ex) {}
    return false;
})()) {
