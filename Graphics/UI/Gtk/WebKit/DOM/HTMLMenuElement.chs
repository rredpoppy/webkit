module Graphics.UI.Gtk.WebKit.DOM.HTMLMenuElement(
setCompact,
getCompact,
HTMLMenuElement,
castToHTMLMenuElement,
gTypeHTMLMenuElement,
HTMLMenuElementClass,
toHTMLMenuElement,
) where
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

 
setCompact ::
           (MonadIO m, HTMLMenuElementClass self) => self -> Bool -> m ()
setCompact self val
  = liftIO
      ({# call webkit_dom_html_menu_element_set_compact #}
         (toHTMLMenuElement self)
         (fromBool val))
 
getCompact ::
           (MonadIO m, HTMLMenuElementClass self) => self -> m Bool
getCompact self
  = liftIO
      (toBool <$>
         ({# call webkit_dom_html_menu_element_get_compact #}
            (toHTMLMenuElement self)))
