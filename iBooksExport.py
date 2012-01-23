#!/usr/bin/python
#
#python script to export ibooks highlights from ibooks databases
#
#highlights and notes are in the below file
#Documents/storeFiles/AEAnnotation_v..._local.sqlite
#
#in the ZAEANNOTATION TABLE
#
#the Note is in the ZANNOTATIONOTE field
#the Highlight is in the ZANNOTATIONSELECTEDTEXT field
#the book id is in the ZANNOTATIONASSETID field
#
#the book to ZANNOTATIONASSETID map is in the
#Documents/BKLibrary_database/iBooks_v....sqlite file
#
#in the ZBKBOOKINFO table
#
#The book id is in the ZBOOKUNIQUEID field
#The book title is in the ZBOOKTITLE field
#if the book has DRM then the book id is in the ZDATABASEKEY field
#ZDATABASEKEY and ZBOOKUNIQUEID are equal in all cases when the book is not DRMed. So ignore ZBOOKUNIQUEID and only use ZDATABASEKEY.
#

import sqlite3 as lite
import sys

#get command line arguement for the names of the database files
iBooksDB = sys.argv[1]
tempArg = sys.argv[2]
notesDB = ""

#correctly attribute database file names
if iBooksDB[:2] == "iB":
    notesDB = tempArg
else :
    notesDB = iBooksDB
    iBooksDB = tempArg

#print db names
print "iBooks = " + iBooksDB

#connection to book titles db
dbConnection = lite.connect(iBooksDB)

with dbConnection : 
    
    dbConnection.row_factory = lite.Row
       
    cur = dbConnection.cursor()
    cur.execute ('select ZDATABASEKEY, ZBOOKTITLE from ZBKBOOKINFO')
    
    rows = cur.fetchall()
    
    for row in rows:
        print " %s %s" % (row["ZDATABASEKEY"], row["ZBOOKTITLE"])
        #add the bdkey and book title to a dictionary for reference later

#connection to notes db
dbConnection = lite.connect(notesDB)

with dbConnection :
    
    dbConnection.row_factory = lite.Row

    cur = dbConnection.cursor()
    cur.execute ('select ZANNOTATIONNOTE, ZANNOTATIONSELECTEDTEXT, ZANNOTATIONASSETID from ZAEANNOTATION')

    rows = cur.fetchall()
    
    for row in rows:

        compareValue = row["ZANNOTATIONSELECTEDTEXT"]

        
        if str(compareValue) != "None":
            print " %s %s %s" %  (row["ZANNOTATIONNOTE"], row["ZANNOTATIONSELECTEDTEXT"], row["ZANNOTATIONASSETID"])
            #this is where we would only output if the selected text was not null
            #would create the object that holds the book title and all notes and highlights


