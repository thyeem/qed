# qed

_Quod Erat Demonstrandum_. _Q.E.D._

__Back up your data with QR codes anywhere and anyplace.__  (_warning: It's deadly inefficient, as you know._ `'-']b`)

This is heavily inspired by https://github.com/alisinabh/paperify.

`qed` improved usability and added some features.

- `qed` creates some bytes of header when encoding so that it gives some information when decoded.
- Once encoded by `qed`, it __can be restored at any moment__.

  - Even if multiple kinds of backups are __mixed and duplicated within a single directory__...
  - Even if the file names are not sorted... (_acutally, the file names have nothing to do with recovery_)



## Install
```sh
# prerequisites
# ffmpeg is optional as only used with '-p' option.
$ brew install zbar qrencode jq imagemagick ffmpeg

# clone
$ git clone https://github.com/thyeem/qed.git

# put the 'qed' file in $PATH direcoty like $HOME/.local/bin/ if needed
$ cp qed $HOME/.local/bin

# test (optional)
# check it out if you want to know it works well. This may take a while.
$ sh test.sh
```

## Usage
```plain
 qed - backup using QR encode/decode

 . encode :: [FILE] -> DIR

      qed -e [-o OUT-DIR] [-s CELL-SIZE] [-m MARGIN]
             [-v VERSION] [-l ERROR-CORRECTION-LEVEL] [-t DATA-TYPE]
             [-1 QR-COLOR-FG] [-0 QR-COLOR-BG] [-p] [-q] FILE ...


 . decode :: DIR -> [FILE]

      qed -d [-r RESIZE-RATIO(%) ] [-o OUT-FILE] DIR


 options:
      -p    Create and play QRcode slideshows after encoding is finished
      -q    Open output QRcode images in browser after encoding is finished
      -s    Set cell size of QRcode"         (default: 15)
      -m    Set margin of QRcode             (recommended 4+, default: 8)
      -1    Set foreground color of QRcode   (6-hexadecimal, default: 000000)
      -0    Set background color of QRcode   (6-hexadecimal, default: ffffff)
      -r    Set resize-ratio if needed       (6-hexadecimal, default: 25%)
      -v    Set version of QRcode            (1 to 40, default: 38)
      -l    Set QR error correction level    (one of [L,M,Q,H], default: L)
      -t    Set type of input data           (one of [A,B,D,K,N], default: B)
            A-Alphanumeric, B-Binary, D-Databits, K-Kanji, and N-Numeric
```


## Example
```sh
# say FILE is the file to encode
# if no -o option, encode automatically into temp dir (notify after completion)
$ qed -e FILE

# suppose that files to decode are in 'DIR'
$ qed -d DIR

# no problem with encoding multiple files at once
# all results go to the temp output dir
$ qed -e FILE1 FILE2 FILE3 ...

# no problem in restoring the original files in the previous example.
# say DIR-OF-MIXED-FILES is where files were mixed. (no worries duplicated data either)
$ qed -d DIR-OF-MIXED-FILES

# encode via <stdin>
$ cat FILE | qed -e

# also decode supports <stdin>
$ cat FILE | qed -e | qed -d

# what would be the result?
# it's done a lot of work of encoding and decoding,
# but the result is the same to the file at first, FILE.
$ cat FILE | qed -e | qed -d | xargs cat | qed -e | qed -d | xargs qed -e | qed -d

# pretty sure that both are the same!
# $(curl -s www.google.com) == $(cat /tmp/google)
$ curl -s www.google.com | qed -e | qed -d | xargs cat > /tmp/google

# open a video (QR code slideshows) when encoding is finished
$ qed -e -p FILE        # or -ep

# open QR code images on browser when encoding is finished
$ qed -e -q FILE        # or -eq

# set output directory to /tmp/tmp
$ qed -e -o /tmp/tmp FILE

# encode/decode with full of options
$ qed -e -q -s 10 -m 16 -1 333333 -0 e0ffff -v 30 -l M -t K -o /tmp/tmp FILE | qed -d -r 33%
```

## Identity transform
From the `qed` signatures of operation the below, we can easily guess `identity transform`.

```
encode :: [FILE] -> DIR

decode :: DIR -> [FILE]

I = decode . encode
  = (DIR -> [FILE]) . ([FILE] -> DIR)
  = [FILE] -> [FILE]
  = id
```

In `SHELL` notation,


- _i) when using `<stdin>`_ ⟹ `( | qed -e | qed -d )`

  ```
  I = decode . encode
    = (qed -d) . (qed -e)
    = | qed -e | qed -d

  stream = I (stream)
  stream | qed -e | qed -d  ⟹  stream

  $ cat FILE | qed -e | qed -d  ⟹  (cat FILE)
  ```


- _ii) when using `args`_ ⟹ `( | xargs qed -e | qed -d )`

  ```
  I = decode . encode
    = (qed -d) . (qed -e)
    = | xargs qed -e | qed -d

  args = I (args)
  args | xargs qed -e | qed -d  ⟹  args

  $ echo FILE1 FILE2 ... | xargs qed -e | qed -d  ⟹  "FILE1" "FILE2" ...
  ```
