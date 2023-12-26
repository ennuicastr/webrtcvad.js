CC=emcc
CFLAGS=-Oz

EFLAGS=\
	--memory-init-file 0 --pre-js pre.js --post-js post.js \
	-s "EXPORT_NAME='WebRtcVad'" \
	-s "EXPORTED_FUNCTIONS=['_WebRtcVad_Create', '_WebRtcVad_Init', '_WebRtcVad_Free', '_WebRtcVad_set_mode', '_WebRtcVad_Process', '_malloc', '_free']" \
	-s "EXPORTED_RUNTIME_METHODS=['cwrap']" \
	-s MODULARIZE=1 \
	-Iwebrtc \
	-DWEBRTC_POSIX

WEBRTCVAD_SRC= \
	stubs.c \
	webrtc/common_audio/vad/webrtc_vad.c \
	webrtc/common_audio/signal_processing/spl_init.c \
	webrtc/common_audio/signal_processing/cross_correlation.c \
	webrtc/common_audio/signal_processing/downsample_fast.c \
	webrtc/common_audio/signal_processing/min_max_operations.c \
	webrtc/common_audio/signal_processing/vector_scaling_operations.c \
	webrtc/common_audio/vad/vad_core.c \
	webrtc/common_audio/signal_processing/division_operations.c \
	webrtc/common_audio/signal_processing/resample_48khz.c \
	webrtc/common_audio/signal_processing/resample_by_2_internal.c \
	webrtc/common_audio/signal_processing/resample_fractional.c \
	webrtc/common_audio/vad/vad_filterbank.c \
	webrtc/common_audio/signal_processing/energy.c \
	webrtc/common_audio/signal_processing/get_scaling_square.c \
	webrtc/common_audio/vad/vad_sp.c \
	webrtc/common_audio/vad/vad_gmm.c

all: webrtcvad.js

webrtcvad.js: webrtcvad.asm.js webrtcvad.wasm.js
	( \
		cat license.js \
			head.js ; \
		printf 'WebRtcVadWasm="data:application/wasm;base64,' ; \
		base64 -w0 < webrtcvad.wasm | sed 's/$$/";/' ; \
		cat build/webrtcvad.js ; \
		echo '} else {' ; \
		cat build/webrtcvad.asm.js ; \
		echo '}' \
	) > $@
	rm -rf build

webrtcvad.asm.js: $(WEBRTCVAD_SRC) pre.js post.js
	mkdir -p build
	$(CC) $(CFLAGS) $(EFLAGS) $(WEBRTCVAD_SRC) -s WASM=0 -o build/webrtcvad.asm.js
	( \
		cat license.js \
			build/webrtcvad.asm.js \
	) > $@

webrtcvad.wasm.js: $(WEBRTCVAD_SRC) pre.js post.js
	mkdir -p build
	$(CC) $(CFLAGS) $(EFLAGS) $(WEBRTCVAD_SRC) -o build/webrtcvad.js
	chmod a-x build/webrtcvad.wasm
	mv build/webrtcvad.wasm .
	( \
		cat license.js ; \
		printf 'WebRtcVadWasm="data:application/wasm;base64,' ; \
		base64 -w0 < webrtcvad.wasm | sed 's/$$/";/' ; \
		cat build/webrtcvad.js \
	) > $@

clean:
	rm -rf build
	rm -f webrtcvad.js webrtcvad.asm.js webrtcvad.wasm.js webrtcvad.wasm
