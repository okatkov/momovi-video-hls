//-------------------------------------------------------------------------------
// Copyright (c) 2014-2013 NoZAP B.V.
// Copyright (c) 2013 Guillaume du Pontavice (https://github.com/mangui/HLSprovider)
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/. */
// 
// Authors:
//     Jeroen Arnoldus
//     Guillaume du Pontavice
//-------------------------------------------------------------------------------

package org.mangui.HLS.muxing {


    import flash.utils.ByteArray;


    /** Helpers for the FLV file format. **/
    public class FLV {


        /** Return an EOS Video tag (16 bytes). **/
        public static function getEosTag(stamp:Number):ByteArray {
            var tag:ByteArray = FLV.getTagHeader(false,5,stamp);
            // AVC Keyframe.
            tag.writeByte(0x17);
            // Sequence end, composition time
            tag.writeUnsignedInt(0x02000000);
            return tag;
        };


        /** Get the FLV file header. **/
        public static function getHeader():ByteArray {
            var flv:ByteArray = new ByteArray();
            // "F" + "L" + "V".
            flv.writeByte(0x46);
            flv.writeByte(0x4C);
            flv.writeByte(0x56);
            // File version (1)
            flv.writeByte(1);
            // Audio + Video tags.
            flv.writeByte(1);
            // Length of the header.
            flv.writeUnsignedInt(9);
            // PreviousTagSize0
            flv.writeUnsignedInt(0);
            return flv;
        };


        /** Get an FLV Tag header (11 bytes). **/
        public static function getTagHeader(audio:Boolean,length:Number,stamp:Number):ByteArray {
            var tag:ByteArray = new ByteArray();
            // Audio (8) or Video (9) tag
            if(audio) { 
                tag.writeByte(8);
            } else { 
                tag.writeByte(9);
            }
            // Size of the tag in bytes after StreamID.
            tag.writeByte(length >> 16);
            tag.writeByte(length >> 8);
            tag.writeByte(length);
            // Timestamp (lower 24 plus upper 8)
            tag.writeByte(stamp >> 16);
            tag.writeByte(stamp >> 8);
            tag.writeByte(stamp);
            tag.writeByte(stamp >> 24);
            // StreamID (3 empty bytes)
            tag.writeByte(0);
            tag.writeByte(0);
            tag.writeByte(0);
            // All done
            return tag;
        };


    }


}