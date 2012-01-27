#!/usr/bin/ruby

#import sqlite
require 'sqlite3'

#read command line inputs
#unless ARGV.length ==2
#    puts "missing sqlite database arguments"
#    exit

iBooksDB = ARGV[0]
tempArg = ARGV[1]
notesDB = ""

#correctly attribute database file names
if iBooksDB[0,1] == "iB"
    notesDB = tempArg
else
    notesDB = iBooksDB
    iBooksDB = tempArg
end

#puts "notesDB " + notesDB + "\n"
#puts "iBooksList " + iBooksDB + "\n"

#open databases
bookKeyTileDB = SQLite3::Database.open(iBooksDB)
bookNotesDB = SQLite::Database.open(notesDB)

#parse sqlite into a book class
listOfBooks = bookKeyTileDB.execute("select ZDATABASEKEY, ZBOOKTITLE from ZBKBOOKINFO") do |row|
    #for each row
    #iterate through book list
    #get book name and key
    bookName = listOfBooks[1]
    bookNameKey = listOfBooks[0]

    print "hello world"
    puts bookName
    print bookNameKey

    #at each point do a query for notes or highlights
    listOfNotes = bookNotesDB.execute("select ZANNOTATIONNOTE, ZANNOTATIONSELECTEDTEXT, ZANNOTATIONASSETID, ZPLLOCATIONRANGESTART, ZANNOTATIONTYPE from ZAEANNOTATION where ZANNOTATIONTYPE=2 and ZANNOTATIONASSETID = ?", bookNameKey) do |row|


        #add those to the book class obj
    
        end
    
    #print book class
    

    #get next book
    
end
