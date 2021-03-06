module Graphics.UI.Gtk.WebKit.DOM.AudioTrackList(
#if WEBKIT_CHECK_VERSION(2,2,2)
item,
getTrackById,
getLength,
change,
addTrack,
removeTrack,
AudioTrackList,
castToAudioTrackList,
gTypeAudioTrackList,
AudioTrackListClass,
toAudioTrackList,
#endif
) where
#if WEBKIT_CHECK_VERSION(2,2,2)
import Prelude hiding (drop, error, print)
import Data.Typeable (Typeable)
import Foreign.Marshal (maybePeek, maybeWith)
import System.Glib.FFI (maybeNull, withForeignPtr, nullForeignPtr, Ptr, nullPtr, castPtr, Word, Int64, Word64, CChar(..), CInt(..), CUInt(..), CLong(..), CULong(..), CLLong(..), CULLong(..), CShort(..), CUShort(..), CFloat(..), CDouble(..), toBool, fromBool)
import System.Glib.UTFString (GlibString(..), readUTFString)
import Control.Applicative ((<$>))
import Control.Monad (void)
import Control.Monad.IO.Class (MonadIO(..))
import System.Glib.GError
import Graphics.UI.Gtk.WebKit.DOM.EventTargetClosures
import Graphics.UI.Gtk.WebKit.DOM.EventM
{#import Graphics.UI.Gtk.WebKit.Types#}
import Graphics.UI.Gtk.WebKit.DOM.Enums

 
item ::
     (MonadIO m, AudioTrackListClass self) =>
       self -> Word -> m (Maybe AudioTrack)
item self index
  = liftIO
      (maybeNull (makeNewGObject mkAudioTrack)
         ({# call webkit_dom_audio_track_list_item #}
            (toAudioTrackList self)
            (fromIntegral index)))
 
getTrackById ::
             (MonadIO m, AudioTrackListClass self, GlibString string) =>
               self -> string -> m (Maybe AudioTrack)
getTrackById self id
  = liftIO
      (maybeNull (makeNewGObject mkAudioTrack)
         (withUTFString id $
            \ idPtr ->
              {# call webkit_dom_audio_track_list_get_track_by_id #}
                (toAudioTrackList self)
                idPtr))
 
getLength ::
          (MonadIO m, AudioTrackListClass self) => self -> m Word
getLength self
  = liftIO
      (fromIntegral <$>
         ({# call webkit_dom_audio_track_list_get_length #}
            (toAudioTrackList self)))
 
change :: (AudioTrackListClass self) => EventName self Event
change = EventName "change"
 
addTrack :: (AudioTrackListClass self) => EventName self Event
addTrack = EventName "addtrack"
 
removeTrack :: (AudioTrackListClass self) => EventName self Event
removeTrack = EventName "removetrack"
#endif
