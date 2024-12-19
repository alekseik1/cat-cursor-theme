#!/bin/bash
set eux
set -o pipefail

SCALE=64
# SOURCE_DIR="/home/aleksei/Desktop/ezgif-1-b8b98bdac6-jpg"
SOURCE_DIR="/home/aleksei/Desktop/cat-cursor-theme/ezgif-2-eb46f6e532-jpg"
RESC_DIR="/home/aleksei/Desktop/cat-cursor-theme/rescaled"
THEME_DIR="/home/aleksei/Desktop/cat-cursor-theme/KoolKursors"
rm -rf $RESC_DIR/*.png
# for image in $(ls $SOURCE_DIR); do ffmpeg -i $SOURCE_DIR/$image -vf "scale=$SCALE:$SCALE" -compression_level 0 $RESC_DIR/${image%.jpg}.png 2>&1 >/dev/null; done
mkdir -p $RESC_DIR
for image in $(ls $SOURCE_DIR); do ffmpeg -i $SOURCE_DIR/$image -vf "chromakey=0x00FF00:0.2:0.1,format=rgba,scale=$SCALE:$SCALE" -compression_level 0 -c:v png $RESC_DIR/${image%.jpg}.png 2>&1 >/dev/null; done

rm -rf $RESC_DIR/default.cursor
for image in $(ls $RESC_DIR | grep png); do echo "32 8 8 $RESC_DIR/$image 50" >> $RESC_DIR/default.cursor; done
rm -rf $RESC_DIR/default

xcursorgen $RESC_DIR/default.cursor $RESC_DIR/default

echo "making dir"
rm -rf $THEME_DIR
mkdir -p $THEME_DIR/cursors/

cat << EOT >> $THEME_DIR/index.theme
[Icon Theme]
Name=KoolKursors
Comment=Cat cursors
Inherits=breeze_cursors
EOT

cp $RESC_DIR/default $THEME_DIR/cursors/123
ln -s $THEME_DIR/cursors/123 $THEME_DIR/cursors/wait
# ln -s $THEME_DIR/cursors/123 $THEME_DIR/cursors/default
ln -s $THEME_DIR/cursors/123 $THEME_DIR/cursors/watch

echo "copying to target dir"
cp -r $THEME_DIR ~/.local/share/icons/
