# qed

_Quod Erat Demonstrandum_. _Q.E.D._

__Back up your data with QR codes anywhere and anyplace.__  _(warning: It's deadly inefficient. `'-']b`)_

This highly inspired by https://github.com/alisinabh/paperify.

This improved usability and added some features.

- `qed` creates some bytes of header when encoding
- so that it gives some information when decoded.
- can handle many kinds of data, or a mixture and duplicates of them



## Install
```sh
# prerequisites
$ brew install zbar qrencode

# clone
$ git clone https://github.com/thyeem/qed.git

# put the 'qed' file in $PATH direcoty like $HOME/.local/bin/ if needed
$ cp qed $HOME/.local/bin

```

## Usage
```plain

qed - backup using QR encode/decode

[encode]
    qed -e [-b SPLIT-BYTE] [-s CELL-SIZE] [-m MARGIN] [-o OUT-DIR]
           [-v VERSION] [-l ERROR-CORRECTION-LEVEL] [-q]
           [-1 QR-COLOR-BG] [-0 QR-COLOR-FG] FILE

[decode]
    qed -d [-r RESIZE-RATIO(%) ] [-o OUT-FILE] DIR


options:
     -b    split-byte-size when data is large enough  (depends on '-l')
     -s    cell size of QR-code
     -m    margin of QR-code  (recommended 4+)
     -v    version of QR-code  (1 to 40)
     -l    error correction level of QR-code  (one of [L,M,Q,H])
     -q    open output qr-images to the browser when encoding is finished
     -1    foreground color of QR-code  (6-hexadecimal)
     -0    background color of QR-code  (6-hexadecimal)
     -r    set resize-ratio if resizing is needed  (6-hexadecimal)

```


## Example
```sh
## encode:
# data to encode -> 'qed' file  (encode itself!)
# encoding 'qed' file into QR codes in /tmp/backup dir
$ qed -e -o /tmp/backup qed

# open QR code images on browser when encoding is finished
$ qed -e -o /tmp/backup -q qed

# with various options
$ qed -e -q -b 500 -s 10 -m 32 -v 40 -l Q -1 cccccc -0 e0ffff -o /tmp/backup qed

## decode:
$ qed -d /tmp/backup

```
