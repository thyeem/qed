# qed

<img src="data/slideshow.gif" width="480" />

_Quod Erat Demonstrandum_. _Q.E.D._

__Encode any data into a tar stream of QR code images.__

Seriously? Yes, we are. `'-']b`

As you know, this is deadly inefficient in terms of _storage_ and _encoding/decoding time_. Due to this inefficiency, it would not be great for simple backup purpose. However, __we believe it may have useful uses__.

## Quick Start
```bash
# encode stream (stdin) -> tar-stream (stdout)
$ cat FILE | qed

# decode tar-stream (stdin) -> stream of the original contents (stdout)
$ cat FILE | qed | qed -d

# encode FILE_OR_DIR via argument -> tar-stream (stdout)
$ qed FILE_OR_DIR

# encode FILE_OR_DIR via argument -> filepath of TAR_FILE (stdout)
$ qed FILE_OR_DIR > TAR_FILE

# the same as above
$ qed -o TAR_FILE FILE_OR_DIR

# create a video as a QR code slideshow
$ qed -p FILE_OR_DIR

# create a HTML of QR code images
$ qed -q FILE_OR_DIR

# decode TAR_FILE via argument -> the original data's stream (stdout)
$ qed -d TAR_FILE

# can also decode a single IMAGE (*.png, *.jpg, ...) -> the original data's stream (stdout)
$ qed -d IMAGE

# can also decode a single VIDEO (*.mp4, *.mov, ...) -> the original data's stream (stdout)
$ qed -d VIDEO

# can also decode DIRECTORY conataining IMAGE(s) -> the original data's stream (stdout)
# data are automatically selected if various kinds of data are mixed.
$ qed -d DIRECTORY

# decode TAR_FILE via argument -> filepath of a single concatanated file (stdout)
$ qed -d TAR_FILE > FILE

# decode TAR_FILE via argument -> filepath of NEW_DIR of the original contents (stdout)
$ qed -d -o NEW_DIR TAR_FILE

# -v increases verbosity. it shows the details how the work is progressing.
$ qed -v FILE_OR_DIR | qed -dv
```
For more detailed options, refer to the [Usage](https://github.com/thyeem/qed#usage) and [More Examples](https://github.com/thyeem/qed#more-examples) section below.


## Features
In short, once encoded any data by `qed`, it __can be restored by `qed` at any moment__.

- __Decodes deterministically__ even in ambiguous or conflicting cases, no matter of
   * _data duplication_
   * _filename corruption_
   * _file unsorting_
   * _filepath relocation_.

- Fully support for setting [version](https://en.wikipedia.org/wiki/QR_code#Storage) and [error correction level](https://en.wikipedia.org/wiki/QR_code#Error_correction) of the QR code.

- Uses `stdout` by default as encoder/decoder output.
  > If not provided `-o filepath` option, __output to `stdout` is the default__.

- Creates some bytes of header when encoding, and provides some information when decoding.


`qed` is heavily inspired by https://github.com/alisinabh/paperify.
We have improved usability and added some features.


## Install
```bash
# prerequisites
# ffmpeg is optional as only used with '-p' option.
$ brew install zbar qrencode imagemagick ffmpeg

# clone
$ git clone https://github.com/thyeem/qed.git
$ cd qed

# put the 'qed' file in $PATH direcoty like $HOME/.local/bin/ if needed
$ chmod +x qed && cp $_ $HOME/.local/bin

# check it out if you want to know it works well. This may take a while.
$ sh test.sh
```

## Usage
```qed
$ qed -h
 qed - encode data into a tar stream of QR Code images

 Usage: qed [-hdpqzv] [-o output] [-V version] [-l error-correction-level] [-r framerate]
            [-s cell-size] [-m margin] [-1 qr-fg-color] [-0 qr-bg-color] filepath

      -h    print this message
      -d    decode input
      -p    create QR Code slideshow (mp4) after encoding is finished
      -q    create QR Code quick-view (HTML document) after encoding is finished
      -v    show in detail how the work is progressing
      -r    set QR code slideshow framerate  (default: 1)
      -o    set output filepath              (default: '-' for stdout)
      -s    set cell size of QR Code         (default: 13)
      -m    set margin of QR Code            (recommended 4+,   default: 24)
      -V    set version of QR Code           (1 to 40,          default: 40)
      -l    set error correction level       (one of [L,M,Q,H], default: L)
      -1    set foreground color of QR Code  (6-hexadecimal,    default: 000000)
      -0    set background color of QR Code  (6-hexadecimal,    default: ffffff)
```


## More Examples
```bash
# get the encoding result of QR images in the current dir
$ qed FILE_OR_DIR | tar xv

# get the encoding result of QR images in the specified DIR
$ qed FILE_OR_DIR | tar xv -C DIR

# compress the QR code tarball after encoding
$ cat FILE | qed | gzip -c > tmp.tar.gz

# uncompress the tar.gz archive then decode. go back to FILE again
$ gunzip -c tmp.tar.gz | qed -d

# create and play a mp4 video (QR code slideshow) when encoding is finished
$ qed -p FILE | xargs open

# create and open QR code images on browser when encoding is finished
$ qed -q FILE | xargs open

# stream -> tar stream -> stream
$ curl -sL https://google.com | qed | qed -d

# stream -> QR-image mp4 file -> stream
$ curl -sL https://google.com | qed -p | xargs qed -d

# FILE_OR_DIR -> tar stream -> NEW_DIR of the original contents
$ qed FILE_OR_DIR | qed -d -o NEW_DIR

# with other encoder
$ echo "QED: QR.Encoder.Decoder" | base64 | qed | qed -d | base64 -d

# backing up directory with qed: does the same thing as tar
# $ tar -cvf - FROM_DIR | tar -xv -C TO_DIR
$ qed -v FROM_DIR | qed -dv -o TO_DIR
```
