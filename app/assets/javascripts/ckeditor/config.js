if (typeof(CKEDITOR) != 'undefined') {
            CKEDITOR.editorConfig = function( config )
            {
              config.toolbar = 'MyToolbar';

              config.toolbar_MyToolbar =
                [
                    { name: 'basicstyles', items : [ 'Bold','Italic' ] },
                    { name: 'links', items : [ 'Link','Unlink' ] },
                    { name: 'insert', items : [ 'Image' ] },
                    { name: 'paragraph', items : [ 'BulletedList' ] },

                ];
            config.height = '143px';
            config.width = '100%';
config.enterMode = CKEDITOR.ENTER_BR;
   config.shiftEnterMode = CKEDITOR.ENTER_BR;
   config.autoParagraph = false;
  };
}
