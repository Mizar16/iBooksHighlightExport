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

#book to key map
dictKeyBook = {}

#connection to book titles db
dbConnection = lite.connect(iBooksDB)

with dbConnection : 
    
    dbConnection.row_factory = lite.Row
       
    cur = dbConnection.cursor()
    cur.execute ('select ZDATABASEKEY, ZBOOKTITLE from ZBKBOOKINFO')
    
    rows = cur.fetchall()
    
    for row in rows:
        #add the bdkey and book title to a dictionary for reference later
        #the below could be an error of converstion to ascii from unicode
        # if we convert here we have to convert the key when it is encountered later
        dictKeyBook[str(row["ZDATABASEKEY"])] = row["ZBOOKTITLE"]

#print dictKeyBook

#connection to notes db
dbConnection = lite.connect(notesDB)

flag = True
with dbConnection :
    
    dbConnection.row_factory = lite.Row

    cur = dbConnection.cursor()
    cur.execute ('select ZANNOTATIONNOTE, ZANNOTATIONSELECTEDTEXT, ZANNOTATIONASSETID from ZAEANNOTATION')

    rows = cur.fetchall()

    #for each row we want to parse the data
    for row in rows:
       #some strings are ascii and some are unicode, if a string converts to ascii with out
        #issue then we want to compare that to None. if true then we dont care about that
        # row. if it errors out then we certainly want the data from that row
        try :
            compareString = str(row["ZANNOTATIONNOTE"])
            
            if compareString != "None" :
                print " "
                print " %s %s %s" %  (row["ZANNOTATIONNOTE"], row["ZANNOTATIONSELECTEDTEXT"], row["ZANNOTATIONASSETID"])
                flag = False
                
        except:
            if flag :                
                print " "
                print " %s %s %s" %  (row["ZANNOTATIONNOTE"], row["ZANNOTATIONSELECTEDTEXT"], row["ZANNOTATIONASSETID"])
                flag = True





