# -*- coding: utf-8 -*-
"""
Created on Tue Aug  2 17:16:22 2022

@author: vicanmendez
DESCRIPTION: This little script allows us to translate a Wordpress Plugin without loading extra plugins and avoiding slowing down our site
INSTRUCTIONS - HOW TO TRANSLATE A PLUGIN?: 
1) Go to your site folder/wp-content/plugins/your-plugin/languages and download the plugin-en_US.po file
2) Copy the content of this .PO file into a DOC file or another document that can be uploaded to Google Translator 
3) Translate the file and download the translated file. Will be easier to use a simple name and put the content into a TXT file.
4) You will need both files, the original text and the translated one, and save them into the folder you load into the open() functions
    For instance, we have two files in our 'Downloads' folder, two files, US.txt contains the original english PO for the plugin, AR.txt is the same content but translated to Spanish AR with Google Translator
5) Then you have to copy the resultant translated PO file into your-plugin/languages folder with the correct .PO extension (i.e myPlugin-es_UY.po)
6) Your translation file should be ready. Don't work? Be sure your WP global config is using the exact language that you are loading the translation, then go to Loco Translate plugin settings - select your plugin - select your desired lang (it should be ready) and download the .MO (compiled) file
7) Save your .MO resultant file and copy (or upload) it to your-plugin/languages folder. Now, it just be ready
"""

import os

#Function must receive two lists with WP translation text, the first with the original English, the second, the original file translated to Spanish
def translate_PO(original, destination):
    result_list = []
    i=0
    temp_str = ''
    for line in original:
        if(len(line) > 1): #this is not an empty space
            if(line[:5] == 'msgid'):
                temp_str = destination[i][6:] #translated str
            if(line[:6] == 'msgstr'):
                temp_str = original[:6] + temp_str #should carry the translated string from last iteration
                print(temp_str)
                result_list.append(temp_str)
                temp_str = ''
            else:
                result_list.append(line) #normal line
        i += 1
    return result_list
    

translated_PO = []

#If this file is running into our personal workspace and the file is in our "Download" folder, then we have to format the file path to access it
current_dir = os.path.abspath(os.getcwd())
originalFile = open(current_dir + "/Downloads/US.txt", "r", encoding="utf8")
with originalFile as archivo:
    originalData = archivo.readlines()
originalFile.close()

current_dir = os.path.abspath(os.getcwd())
translatedFile = open(current_dir + "/Downloads/AR.txt", "r", encoding="utf8")
with translatedFile as archivo:
    translatedData = archivo.readlines()
translatedFile.close()

translated_PO = translate_PO(originalData, translatedData)
try:
    f = open(current_dir + "/Downloads/ES_AR.txt", "w") #then must be renamed as nameOfYourPlugin-es_AR.po -supossing Spanish Argentina-
    f.writelines(translated_PO)
    f.close()
except:
    print ('There was an error saving the resultant file')
    

