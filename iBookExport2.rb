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
if iBooksDB[0,2] == "iB"
    notesDB = tempArg
#	puts "TRUE"
else
    notesDB = iBooksDB
    iBooksDB = tempArg
#	puts "False"
end

#puts "notesDB " + notesDB + "\n"
#puts "iBooksList " + iBooksDB + "\n"

#open databases
bookKeyTileDB = SQLite3::Database.open(iBooksDB)
bookNotesDB = SQLite3::Database.open(notesDB)

#parse sqlite into a book class
bookKeyTileDB.execute("select ZDATABASEKEY, ZBOOKTITLE from ZBKBOOKINFO") do |row|
    #for each row
    #iterate through book list
    #get book name and key
    bookName = row[1]
    bookNameKey = row[0]

    puts bookName + " : " + bookNameKey

    #at each point do a query for notes or highlights
    bookNotesDB.execute("select ZANNOTATIONNOTE, ZANNOTATIONSELECTEDTEXT, ZANNOTATIONASSETID, ZPLLOCATIONRANGESTART, ZANNOTATIONTYPE from ZAEANNOTATION where ZANNOTATIONTYPE=2 and ZANNOTATIONASSETID = ?", bookNameKey) do |notes|

        #add those to the book class obj
		if notes[0]!=nil
			#	puts "::"+ notes[0] + "::"+notes[1]+"::"+notes[2]
			#	notes[0] is note, notes[1] is highlight
			#	make a class
			#	add notes and to that class

		end
    end
    
    #print book class
    puts "********************\n"

    #get next book
    
end
