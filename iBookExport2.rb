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

if ARGV[0] == nil
	puts "argument error"
end

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

   # puts bookName + " : " + bookNameKey


   	bookNotesDB.execute("select ZANNOTATIONASSETID, ZANNOTATIONTYPE from ZAEANNOTATION where ZANNOTATIONTYPE=2 and ZANNOTATIONASSETID = ?", bookNameKey) do |noteExistTest|
		if noteExistTest[0] != nil
			bookFile = File.open("bookNote/"+bookName[0,30]+".txt","w+")
			#print book name
			bookFile << bookName+"\n"
			bookFile << "---------------------------------\n\n"
			bookFile.close()
		
			#at each point do a query for notes or highlights
			bookNotesDB.execute("select ZANNOTATIONNOTE, ZANNOTATIONSELECTEDTEXT, ZANNOTATIONASSETID, ZPLLOCATIONRANGESTART, ZANNOTATIONTYPE, ZANNOTATIONDELETED from ZAEANNOTATION where ZANNOTATIONTYPE=2 and ZANNOTATIONDELETED = 0 and ZANNOTATIONASSETID = ? order by ZPLLOCATIONRANGESTART", bookNameKey) do |notes|
		
				bookFile = File.open("bookNote/"+bookName[0,30]+".txt","a")

				#add those to the book class obj
				if notes[1]!=nil
					#	puts "::"+ notes[0] + "::"+notes[1]+"::"+notes[2]
					#	notes[0] is note, notes[1] is highlight
					#	print notes and highlights
					bookFile << "Highlight:\n"
					bookFile << "---------------------------------\n"
					bookFile << "		"+notes[1]+"\n\n"
					if notes[0]!=nil
						bookFile << "Note:\n"
						bookFile << "---------------------------------\n"
						bookFile << "		"+notes[0]+"\n\n\n"
					end
				end
				bookFile.close()
			end
		end
	end    
end
