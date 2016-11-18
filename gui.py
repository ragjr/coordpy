##import Tkinter
##import tkMessageBox
##
##top = Tkinter.Tk()
##
##def helloCallBack():
##   tkMessageBox.showinfo( "Hello Python", "Hello World")
##
##B = Tkinter.Button(top, text ="Hello", command = helloCallBack)
##
##B.pack()
##top.mainloop()

import Tkinter
import tkMessageBox
from Tkinter import *

top = Tk()
L1 = Label(top, text="User Name")
L1.pack( side = LEFT)
E1 = Entry(top, bg='blue')

E1.pack(side = RIGHT)

def helloCallBack():
   tkMessageBox.showinfo( "Hello Python", "Hello World")

B = Tkinter.Button(top, text ="Hello", command = helloCallBack)

B.pack()

top.mainloop()
