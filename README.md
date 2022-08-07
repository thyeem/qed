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
$ brew install zbar qrencode jq imagemagick

# clone
$ git clone https://github.com/thyeem/qed.git

# put the 'qed' file in $PATH direcoty like $HOME/.local/bin/ if needed
$ cp qed $HOME/.local/bin

# test (optional)
# check it out if you want to know it works well. This may take a while.
$ bash test.sh

```

## Usage
```plain
 qed - backup using QR encode/decode

 . encode :: [FILE] -> DIR

      qed -e [-o OUT-DIR] [-s CELL-SIZE] [-m MARGIN]
             [-v VERSION] [-l ERROR-CORRECTION-LEVEL] [-t DATA-TYPE]
             [-1 QR-COLOR-FG] [-0 QR-COLOR-BG] [-q] FILE ...


 . decode :: DIR -> [FILE]

      qed -d [-r RESIZE-RATIO(%) ] [-o OUT-FILE] DIR


 options:
      -q    Open output images to browser when encoding is finished"
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
## encode:
# encoding 'qed' file (encode itself!) into QR codes in /tmp/backup dir
$ qed -e -o /tmp/backup qed

# open QR code images on browser when encoding is finished
$ qed -e -o /tmp/backup -q qed

# with various options
$ qed -e -q -s 10 -m 32 -v 30 -l Q -t N -1 cccccc -0 e0ffff -o /tmp/backup qed

## decode:
$ qed -d /tmp/backup

```
