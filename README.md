
#ruby script to export ibooks highlights from ibooks databases.

###Usage:

The ruby script takes two (and only two) arguments. They are the fileNames of the sqlite database files needed to extract info from. Notes for each book will be their own file and outputed into the bookNotes directory.

First you need to export the two required databases. Currrently you can extract these from an iOS back up using this tool http://supercrazyawesome.com/ or using a iOS device viewer like phoneView.

With either method you will find an ibooks directory. In that directory you will find the two databases:
AEAnnotation_v..._local.sqlite  and  iBooks_v....sqlite
The '...' are a seamingly random series of numbers. To my understanding numbers are the same for each device but I havnt tested that. 

The script executes on these two dbs to export your notes and highlights. Place these two databases in the same directory as the ruby script.


##SQLite Developer notes

Highlights and notes are in the below database:
- Documents/storeFiles/AEAnnotation_v..._local.sqlite

In the ZAEANNOTATION TABLE:

- The Note is in the ZANNOTATIONOTE field
- The Highlight is in the ZANNOTATIONSELECTEDTEXT field
- The book id is in the ZANNOTATIONASSETID field
- The ZANNOTIONTYPE is to make sure it is a highlight or a note. This way you can avoid reading list book marks and the like. This value is 2 to indicate a note or highlight 
- The ZPLLOCATIONRANGESTART field may the location of the note/highlight. this is to help sort the order of notes later. I still havnt figured out how to put the notes/highlihgts in order.
- The ZANNOTATIONDELETED field is to indicate if the note/highlight was delected or not. a value of 1 means it was deleted. The script will not collect deleted highlights or notes

The book to ZANNOTATIONASSETID map is in the
- Documents/BKLibrary_database/iBooks_v....sqlite database

In the ZBKBOOKINFO table:
- The book id is in the ZBOOKUNIQUEID field
- The book title is in the ZBOOKTITLE field
- If the book has DRM then the book id is in the ZDATABASEKEY field
- ZDATABASEKEY and ZBOOKUNIQUEID are equal in all cases when the book is not DRMed. So ignore ZBOOKUNIQUEID and only use ZDATABASEKEY.


