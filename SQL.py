import sqlite3

conn=sqlite3.connect("tutorial.db")
c=conn.cursor()

def tableCreate():
    c.execute("create table stufftoPlot(ID INT, unix REAL,datestamp TEXT, keyword TEXT, value REAL)")


tableCreate()
    
