-- |GIMP Toolkit (GTK) Binding for Haskell: binding to GConf   -*-haskell-*-
--    for storing and retrieving configuartion information
--
--  Author : Duncan Coutts
--  Created: 24 April 2004
--
--  Copyright (c) 2004 Duncan Coutts
--
--  This library is free software; you can redistribute it and/or
--  modify it under the terms of the GNU Library General Public
--  License as published by the Free Software Foundation; either
--  version 2 of the License, or (at your option) any later version.
--
--  This library is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--  Library General Public License for more details.
--
--- Description ---------------------------------------------------------------
--
--  Language: Haskell 98 Binding Module
--
--  The file chooser dialog & widget is a replacement (introduced with gtk+ 2.4)
--  for the old and ugly GtkFileSelection dialog. It provides a better user
--  interface and an improved API
--
--  The FileChooser (as opposed to the dialog or widget) is the interface that
--  the FileChooserDialog & FileChooserWidget implement, all the operations
--  except construction are on this interface
--

module FileChooser (
  FileChooserClass,
  FileChooser,
  FileChooserAction(..),
  fileChooserSetAction,
  fileChooserGetAction,
  fileChooserSetLocalOnly,
  fileChooserGetLocalOnly,
  fileChooserSetSelectMultiple,
  fileChooserGetSelectMultiple,
  fileChooserSetCurrentName,
  fileChooserGetFilename,
  fileChooserSetFilename,
  fileChooserSelectFilename,
  fileChooserUnselectFilename,
  fileChooserSelectAll,
  fileChooserUnselectAll,
  fileChooserGetFilenames,
  fileChooserSetCurrentFolder,
  fileChooserGetCurrentFolder,
  fileChooserGetURI,
  fileChooserSetURI,
  fileChooserSelectURI,
  fileChooserUnselectURI,
  fileChooserGetURIs,
  fileChooserSetCurrentFolderURI,
  fileChooserGetCurrentFolderURI,
  fileChooserSetPreviewWidget,
  fileChooserGetPreviewWidget,
  fileChooserSetPreviewWidgetActive,
  fileChooserGetPreviewWidgetActive,
  fileChooserSetUsePreviewLabel,
  fileChooserGetUsePreviewLabel,
  fileChooserGetPreviewFilename,
  fileChooserGetPreviewURI,
  fileChooserSetExtraWidget,
  fileChooserGetExtraWidget,
  fileChooserAddFilter,
  fileChooserRemoveFilter,
  fileChooserListFilters,
  fileChooserSetFilter,
  fileChooserGetFilter,
  fileChooserAddShortcutFolder,
  fileChooserRemoveShortcutFolder,
  fileChooserlistShortcutFolders,
  fileChooserAddShortcutFolderURI,
  fileChooserRemoveShortcutFolderURI,
  fileChooserListShortcutFolderURIs
) where

import Monad (liftM, when)
import FFI
{#import Hierarchy#}
import Object		(makeNewObject)
{#import GList#}
import Structs (GError(..))

{# context lib="gtk" prefix ="gtk" #}

{# enum FileChooserAction {underscoreToCase} #}
{# enum FileChooserError {underscoreToCase} #}

fileChooserSetAction :: FileChooserClass chooser => chooser -> FileChooserAction -> IO ()
fileChooserSetAction chooser action =
  {# call gtk_file_chooser_set_action #} (toFileChooser chooser)
    (fromIntegral $ fromEnum action)

fileChooserGetAction :: FileChooserClass chooser => chooser ->  IO FileChooserAction
fileChooserGetAction chooser = liftM (toEnum . fromIntegral) $
  {# call gtk_file_chooser_get_action #} (toFileChooser chooser)

fileChooserSetLocalOnly :: FileChooserClass chooser => chooser -> Bool -> IO ()
fileChooserSetLocalOnly chooser localOnly = 
  {# call gtk_file_chooser_set_local_only #} (toFileChooser chooser)
    (fromBool localOnly)

fileChooserGetLocalOnly :: FileChooserClass chooser => chooser -> IO Bool
fileChooserGetLocalOnly chooser = liftM toBool $
  {# call gtk_file_chooser_get_local_only #} (toFileChooser chooser)

fileChooserSetSelectMultiple :: FileChooserClass chooser => chooser -> Bool -> IO ()
fileChooserSetSelectMultiple chooser selectMultiple = 
  {# call gtk_file_chooser_set_select_multiple #} (toFileChooser chooser)
    (fromBool selectMultiple)

fileChooserGetSelectMultiple :: FileChooserClass chooser => chooser -> IO Bool
fileChooserGetSelectMultiple chooser = liftM toBool $
  {# call gtk_file_chooser_get_select_multiple #} (toFileChooser chooser)

fileChooserSetCurrentName :: FileChooserClass chooser => chooser -> String -> IO ()
fileChooserSetCurrentName chooser name =
  withCString name $ \strPtr ->
  {# call gtk_file_chooser_set_current_name #} (toFileChooser chooser) strPtr

fileChooserGetFilename :: FileChooserClass chooser => chooser -> IO String
fileChooserGetFilename chooser = do
  strPtr <- {# call gtk_file_chooser_get_filename #} (toFileChooser chooser)
  readCString strPtr

fileChooserSetFilename :: FileChooserClass chooser => chooser -> String -> IO Bool
fileChooserSetFilename chooser filename = liftM toBool $
  withCString filename $ \strPtr ->
  {# call gtk_file_chooser_set_filename #} (toFileChooser chooser) strPtr

fileChooserSelectFilename :: FileChooserClass chooser => chooser -> String -> IO Bool
fileChooserSelectFilename chooser filename = liftM toBool $
  withCString filename $ \strPtr ->
  {# call gtk_file_chooser_select_filename #} (toFileChooser chooser) strPtr

fileChooserUnselectFilename :: FileChooserClass chooser => chooser -> String -> IO ()
fileChooserUnselectFilename chooser filename = 
  withCString filename $ \strPtr ->
  {# call gtk_file_chooser_unselect_filename #} (toFileChooser chooser) strPtr

fileChooserSelectAll :: FileChooserClass chooser => chooser -> IO ()
fileChooserSelectAll chooser = 
  {# call gtk_file_chooser_select_all #} (toFileChooser chooser)

fileChooserUnselectAll :: FileChooserClass chooser => chooser -> IO ()
fileChooserUnselectAll chooser = 
  {# call gtk_file_chooser_unselect_all #} (toFileChooser chooser)

fileChooserGetFilenames :: FileChooserClass chooser => chooser -> IO [String]
fileChooserGetFilenames chooser = do
  strList <- {# call gtk_file_chooser_get_filenames #} (toFileChooser chooser)
  fromStringGSList strList

fileChooserSetCurrentFolder :: FileChooserClass chooser => chooser -> String -> IO Bool
fileChooserSetCurrentFolder chooser foldername = liftM toBool $
  withCString foldername $ \strPtr ->
  {# call gtk_file_chooser_set_current_folder #} (toFileChooser chooser) strPtr

fileChooserGetCurrentFolder :: FileChooserClass chooser => chooser -> IO String
fileChooserGetCurrentFolder chooser = do
  strPtr <- {# call gtk_file_chooser_get_current_folder #} (toFileChooser chooser)
  readCString strPtr

fileChooserGetURI :: FileChooserClass chooser => chooser -> IO String
fileChooserGetURI chooser = do
  strPtr <- {# call gtk_file_chooser_get_uri #} (toFileChooser chooser)
  readCString strPtr

fileChooserSetURI :: FileChooserClass chooser => chooser -> String -> IO Bool
fileChooserSetURI chooser uri = liftM toBool $
  withCString uri $ \strPtr ->
  {# call gtk_file_chooser_set_uri #} (toFileChooser chooser) strPtr

fileChooserSelectURI :: FileChooserClass chooser => chooser -> String -> IO Bool
fileChooserSelectURI chooser uri = liftM toBool $
  withCString uri $ \strPtr ->
  {# call gtk_file_chooser_select_uri #} (toFileChooser chooser) strPtr

fileChooserUnselectURI :: FileChooserClass chooser => chooser -> String -> IO ()
fileChooserUnselectURI chooser uri = 
  withCString uri $ \strPtr ->
  {# call gtk_file_chooser_unselect_uri #} (toFileChooser chooser) strPtr

fileChooserGetURIs :: FileChooserClass chooser => chooser -> IO [String]
fileChooserGetURIs chooser = do
  strList <- {# call gtk_file_chooser_get_uris #} (toFileChooser chooser)
  fromStringGSList strList

fileChooserSetCurrentFolderURI :: FileChooserClass chooser => chooser -> String -> IO Bool
fileChooserSetCurrentFolderURI chooser uri = liftM toBool $
  withCString uri $ \strPtr ->
  {# call gtk_file_chooser_set_current_folder_uri #} (toFileChooser chooser) strPtr

fileChooserGetCurrentFolderURI :: FileChooserClass chooser => chooser -> IO String
fileChooserGetCurrentFolderURI chooser = do
  strPtr <- {# call gtk_file_chooser_get_current_folder_uri #} (toFileChooser chooser)
  readCString strPtr

fileChooserSetPreviewWidget :: (FileChooserClass chooser, WidgetClass widget) =>
                               chooser -> widget -> IO ()
fileChooserSetPreviewWidget chooser widget = 
  {# call gtk_file_chooser_set_preview_widget #} (toFileChooser chooser)
    (toWidget widget)

fileChooserGetPreviewWidget :: FileChooserClass chooser => chooser -> IO Widget
fileChooserGetPreviewWidget chooser =
  makeNewObject mkWidget $
  {# call gtk_file_chooser_get_preview_widget #} (toFileChooser chooser)

fileChooserSetPreviewWidgetActive :: FileChooserClass chooser => chooser -> Bool -> IO ()
fileChooserSetPreviewWidgetActive chooser active = 
  {# call gtk_file_chooser_set_preview_widget_active #} (toFileChooser chooser)
    (fromBool active)

fileChooserGetPreviewWidgetActive :: FileChooserClass chooser => chooser -> IO Bool
fileChooserGetPreviewWidgetActive chooser = liftM toBool $
  {# call gtk_file_chooser_get_preview_widget_active #} (toFileChooser chooser)

fileChooserSetUsePreviewLabel :: FileChooserClass chooser => chooser -> Bool -> IO ()
fileChooserSetUsePreviewLabel chooser usePreview = 
  {# call gtk_file_chooser_set_use_preview_label #} (toFileChooser chooser)
    (fromBool usePreview)

fileChooserGetUsePreviewLabel :: FileChooserClass chooser => chooser -> IO Bool
fileChooserGetUsePreviewLabel chooser = liftM toBool $
  {# call gtk_file_chooser_get_use_preview_label #} (toFileChooser chooser)

fileChooserGetPreviewFilename :: FileChooserClass chooser => chooser -> IO String
fileChooserGetPreviewFilename chooser = do
  strPtr <- {# call gtk_file_chooser_get_preview_filename #} (toFileChooser chooser)
  readCString strPtr

fileChooserGetPreviewURI :: FileChooserClass chooser => chooser -> IO String
fileChooserGetPreviewURI chooser = do
  strPtr <- {# call gtk_file_chooser_get_preview_uri #} (toFileChooser chooser)
  readCString strPtr

fileChooserSetExtraWidget :: (FileChooserClass chooser, WidgetClass widget) =>
                             chooser -> widget -> IO ()
fileChooserSetExtraWidget chooser widget = 
  {# call gtk_file_chooser_set_extra_widget #} (toFileChooser chooser)
    (toWidget widget)

fileChooserGetExtraWidget :: FileChooserClass chooser => chooser -> IO Widget
fileChooserGetExtraWidget chooser = 
  makeNewObject mkWidget $
  {# call gtk_file_chooser_get_extra_widget #} (toFileChooser chooser)

fileChooserAddFilter :: FileChooserClass chooser => chooser -> FileFilter -> IO ()
fileChooserAddFilter chooser filter = 
  {# call gtk_file_chooser_add_filter #} (toFileChooser chooser) filter

fileChooserRemoveFilter :: FileChooserClass chooser => chooser -> FileFilter -> IO ()
fileChooserRemoveFilter chooser filter = 
  {# call gtk_file_chooser_remove_filter #} (toFileChooser chooser) filter

fileChooserListFilters :: FileChooserClass chooser => chooser -> IO [FileFilter]
fileChooserListFilters chooser = do
  filterList <- {# call gtk_file_chooser_list_filters #} (toFileChooser chooser)
  filterPtrs <- fromGSList filterList
  mapM (makeNewObject mkFileFilter . return) filterPtrs

fileChooserSetFilter :: FileChooserClass chooser => chooser -> FileFilter -> IO ()
fileChooserSetFilter chooser filter = 
  {# call gtk_file_chooser_set_filter #} (toFileChooser chooser) filter

fileChooserGetFilter :: FileChooserClass chooser => chooser -> IO FileFilter
fileChooserGetFilter chooser = 
  makeNewObject mkFileFilter $
  {# call gtk_file_chooser_get_filter #} (toFileChooser chooser)

fileChooserAddShortcutFolder :: FileChooserClass chooser => chooser -> String -> IO ()
fileChooserAddShortcutFolder chooser foldername =
  propogateGError $ \gerrorPtr ->
  withCString foldername $ \strPtr -> do
  {# call gtk_file_chooser_add_shortcut_folder #} (toFileChooser chooser)
    strPtr gerrorPtr
  return ()

fileChooserRemoveShortcutFolder :: FileChooserClass chooser => chooser -> String -> IO ()
fileChooserRemoveShortcutFolder chooser foldername =
  propogateGError $ \gerrorPtr ->
  withCString foldername $ \strPtr -> do
  {# call gtk_file_chooser_remove_shortcut_folder #} (toFileChooser chooser)
    strPtr gerrorPtr
  return ()

fileChooserlistShortcutFolders :: FileChooserClass chooser => chooser -> IO [String]
fileChooserlistShortcutFolders chooser = do
  strList <- {# call gtk_file_chooser_list_shortcut_folders #}
    (toFileChooser chooser)
  fromStringGSList strList

fileChooserAddShortcutFolderURI :: FileChooserClass chooser => chooser -> String -> IO ()
fileChooserAddShortcutFolderURI chooser folderuri =
  propogateGError $ \gerrorPtr ->
  withCString folderuri $ \strPtr -> do
  {# call gtk_file_chooser_add_shortcut_folder_uri #} (toFileChooser chooser)
    strPtr gerrorPtr
  return ()

fileChooserRemoveShortcutFolderURI :: FileChooserClass chooser => chooser -> String -> IO ()
fileChooserRemoveShortcutFolderURI chooser folderuri =
  propogateGError $ \gerrorPtr ->
  withCString folderuri $ \strPtr -> do
  {# call gtk_file_chooser_remove_shortcut_folder_uri #}
    (toFileChooser chooser) strPtr gerrorPtr
  return ()

fileChooserListShortcutFolderURIs :: FileChooserClass chooser => chooser -> IO [String]
fileChooserListShortcutFolderURIs chooser = do
  strList <- {# call gtk_file_chooser_list_shortcut_folder_uris #}
    (toFileChooser chooser)
  fromStringGSList strList


------------------------------------------------------
-- Utility functions that really ought to go elsewhere

-- like peekCString but then frees the string using g_free
readCString :: CString -> IO String
readCString strPtr = do
  str <- peekCString strPtr
  {# call unsafe g_free #} (castPtr strPtr)
  return str

-- convenience functions for GSlists of strings
fromStringGSList :: GSList -> IO [String]
fromStringGSList strList = do
  strPtrs <- fromGSList strList
  mapM readCString strPtrs

toStringGSList :: [String] -> IO GSList
toStringGSList strs = do
  strPtrs <- mapM newCString strs
  toGSList strPtrs

propogateGError :: (Ptr (Ptr ()) -> IO a) -> IO a
propogateGError action =
  alloca $ \(errPtrPtr  :: Ptr (Ptr GError)) -> do
  result <- action (castPtr errPtrPtr)
  errPtr <- peek errPtrPtr
  when (errPtr /= nullPtr)
       (do (GError dom code msg) <- peek errPtr
           {# call unsafe g_error_free #} (castPtr errPtr)
           fail msg) --TODO perhaps we should throw the GError itself?
  return result