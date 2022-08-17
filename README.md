# qed

<img src="data/slideshow.gif" width="480" />

_Quod Erat Demonstrandum_. _Q.E.D._

__Encode data of any size into a bundle of QR code images.__

Seriously? Yes, we are. `'-']b`

As you know, It's deadly inefficient in terms of _storage_ and _encoding/decoding time_. Due to this inefficiency, it would not be great for simple backup purpose. However, we believe there will be useful uses.

## Quick Start
```bash
# if not provided '-o filepath' option, output to stdout is the default.
# encode output: a tarball of QR images
# decode output: a tarball of the original filepath (dir or file)

# encode via stdin
$ cat FILE | qed

# encode via argument
$ qed FILE

# decode via stdin
$ cat TAR_OF_QR_IMGs | qed -d

# decode via argument
$ qed -d (TAR_OF_QR_IMGs or DIR_OF_QR_IMGs)

# redirection
$ qed FILE -o OUT
$ qed FILE > OUT

$ qed -d -o OUT IN
$ qed -d IN > OUT

# -v increases verbosity. see the details how the work is progressing.
$ qed -v FILE | qed -dv
```
For more detailed options, refer to the `Usage` section below.

## Demo
<img src="data/demo.gif" width="540" />


## Features
`qed` is heavily inspired by https://github.com/alisinabh/paperify. We have simpified to improve usability and added some features.

- Fully support for setting [version](https://en.wikipedia.org/wiki/QR_code#Storage) and [error correction level](https://en.wikipedia.org/wiki/QR_code#Error_correction) of the QR code (used `byte-mode` only)

- Uses `stdout` by default as encoder/decoder output.

- Creates some bytes of header when encoding, and provides some information when decoding.

- _deterministically decodes even when ambiguous or conflicting_
  > __No matter of data duplication, filename corruption, file unsorting or filepath relocation__.
  > (assumed that every header of files is not damaged)

In short, once encoded any data by `qed`, it __can be restored by `qed` at any moment__.


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
```bash
$ qed -h
 qed - encode data of any size into tarballs of QR Code

 Usage: qed [-hdpqzv] [-o output] [-s cell-size] [-m margin]
            [-V version] [-l error-correction-level]
            [-1 qr-fg-color] [-0 qr-bg-color] [-r resize-ratio ] filepath

      -h    print this message
      -d    decode input
      -p    create and play QR Code slideshows after encoding is finished
      -q    open output QR Code images in browser after encoding is finished
      -v    show in detail how the work is progressing
      -o    set output filepath              (default: '-' for stdout)
      -V    set version of QR Code           (1 to 40, default: 40)
      -l    set error correction level       (one of [L,M,Q,H], default: L)
      -s    set cell size of QR Code         (default: 16)
      -m    set margin of QR Code            (recommended 4+, default: 16)
      -1    set foreground color of QR Code  (6-hexadecimal, default: 000000)
      -0    set background color of QR Code  (6-hexadecimal, default: ffffff)
      -r    set resize-ratio if needed       (0-100%, default: auto)
```


## More Examples
```bash
# get the encoded QR images
$ cat FILE | qed | tar x

# redirect output
$ cat FILE | qed -o DESIRED_FILEPATH

# the above is the same as
$ cat FILE | qed | tar x -C DESIRED_FILEPATH

# compress data after encoding
$ cat FILE | qed | gzip -c > OUT

# open a video (QR code slideshows) when encoding is finished
$ qed -p FILE

# open QR code images on browser when encoding is finished
$ qed -q FILE

# identity transform
$ cat FILE | qed | qed -d

# the above is as follows
$ qed FILE | qed -d

# the same
$ qed -o OUT FILE | xargs cat | qed -d

# pretty sure that both are the same!
# $(curl -s www.google.com) == $(cat /tmp/google)
$ curl -s www.google.com | qed | qed -d > /tmp/google

# encode/decode with full of options
$ qed -pq -s 16 -m 16 -1 333333 -0 e0ffff -v 30 -l M -o /tmp/tmp FILE | qed -d
```
