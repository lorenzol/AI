/*
	Naive Bayes text classifier used to detect spam.

	
	Lorenzo Luciano
	
	
*/

import java.io.*;
import java.util.*;
import java.lang.*;

public class NaiveBayesClassifier
{
	static class FrequencyPair 	{
		int freqHam = 0;  // frequency of Ham (nb of Ham in collection)
		int freqSpam = 0; // frequency of Spam (nb of Spam in collection)
	}

	public static void main(String[] args)	throws IOException
	{
		// Location of the directory (the path) taken from the cmd line (first arg)
		File dirLocation = new File(args[0]);

		// Listing of the directory (should contain 2 subdirectories: ham/ and spam/)
		File[] dirListing = new File[0];

		// Check if the cmd line arg is a directory and list it
		if (dirLocation.isDirectory()) {
			dirListing = dirLocation.listFiles();
		}
		else {
			System.out.println("Error: cmd line arg not a directory.\n");
		    Runtime.getRuntime().exit(0);
		}

		// Listings of the two subdirectories (ham/ and spam/)
		File[] filesHam = new File[0];
		File[] filesSpam = new File[0];

		// Check that there are 2 subdirectories
		if (dirListing.length == 2) {
			filesHam = dirListing[0].listFiles();
			filesSpam= dirListing[1].listFiles();
		}
		else {
			System.out.println("Error: specified directory does not contain two subdirectories.\n");
		    Runtime.getRuntime().exit(0);
		}

		
		
		// Create a hash table for the vocabulary
        Hashtable<String, FrequencyPair> vocab = new Hashtable<String, FrequencyPair>();
		FrequencyPair freq = new FrequencyPair();

		// Read the documents and train (compute probabilities)
		// ham
		for (int i = 0; i < filesHam.length; i++) {
			FileInputStream i_s = new FileInputStream(filesHam[i]);
			BufferedReader in = new BufferedReader(new InputStreamReader(i_s));
	        String line;
			String word;

        	while ((line = in.readLine()) != null) {            // read a line
				StringTokenizer st = new StringTokenizer(line);	// parse it into words
				while (st.hasMoreTokens()) 	{
					word = st.nextToken();
									
					//************************************************
                    //Modification to remove garbage from word and covert all to lowercase
					String newWord = fixWord(word);
					word = newWord;
					
					
					if( word.length() >=4)	 // add word only if it is greater than or equal to 4
					{
						if (vocab.containsKey(word)) {				     // if word already in the vocabulary
							freq = (FrequencyPair)vocab.get(word);    // get its frequency from the hashtable
							freq.freqHam++;                          // increment it
							vocab.put(word, freq);                    // and insert it back in the hashtable
						}
						else {  // a new word
							FrequencyPair newFreq = new FrequencyPair();
							newFreq.freqHam = 1;   // (so far) seen once in ham
							newFreq.freqSpam = 0;  // (so far) never seen in spam
							vocab.put(word, newFreq);   // insert it in the hashtable
						}
					} // end if word lenght is >=4
				}
			}
            in.close();
		}

		// do the same with spam directory
		for (int i = 0; i < filesSpam.length; i++) {
			FileInputStream i_s = new FileInputStream(filesSpam[i]);
			BufferedReader in = new BufferedReader(new InputStreamReader(i_s));
	        String line;
			String word;

        	while ((line = in.readLine()) != null){				 // read a line
				StringTokenizer st = new StringTokenizer(line);	 // parse it into words
				while (st.hasMoreTokens()) {
					word = st.nextToken();
					
					//************************************************
                    //Modification to remove garbage from word and covert all to lowercase
					String newWord = fixWord(word);
					word = newWord;
					
										if( word.length() >=4)	 // add word only if it is greater than or equal to 4
					{
						if (vocab.containsKey(word)) {                  // if word already in the vocabulary
							freq = (FrequencyPair)vocab.get(word);   // get its frequency from the hashtable
							freq.freqSpam++;                            // increment it
							vocab.put(word, freq);                   // and insert it back in the hashtable
													
						}
						else {  // a new word
							FrequencyPair freshFreq = new FrequencyPair();
							freshFreq.freqHam = 0;       // never seen in ham
							freshFreq.freqSpam  = 1;     // (so far) seen once in spam
							vocab.put(word, freshFreq);  // insert it in the hashtable
						}
					} // end if word lenght is >=4
				}
			}
            in.close();
		}
		
				
		
		// Print the content of the hash table
		for (Enumeration e = vocab.keys(); e.hasMoreElements(); ) {
			String word;
			word = (String)e.nextElement();
			freq  = (FrequencyPair)vocab.get(word);

            System.out.println(word + "\t in ham: " + freq.freqHam + " in spam: " + freq.freqSpam);
		}
		

		// Now all students must continue from here
		// The vocabulary must be clean: punctuation and digits must be removed, case insensitive, ...
		// A priori class probabilities must be computed from the number of ham and spam messages
		// Conditional probabilities must be computed for every word
		// Zero probabilities must be replaced by a small estimated value
		// Probabilities must be converted to logprobabilities (loglikelihoods).
		// Bayes rule must be applied on new messages, followed by argmax classification (using logprobabilities)
		// Errors must be computed on the test set and a confusion matrix must be generated

		//*********** Testing part ****************************************************
		
		int totalWordsInHam = 0;    //Number of words in Category Ham
		int totalWordsInSpam = 0;   //Number of words in Category Spam
		int totalWordsInVoc = 0;    //Total number of entries in vocabulary
		int countTotal = 0;         //Total number of emails checked
		int countCorrect = 0;       //Total number of emails correctly classified
		double pHam = 0;            //probability of Ham
		double pSpam = 0;           //probablilty of Spam
		
		//Calculate probability of Ham and Spam with all emails		
		pHam = Math.log10((double)filesHam.length/(filesHam.length + filesSpam.length));
		pSpam = Math.log10((double)filesSpam.length/(filesHam.length + filesSpam.length));
		
		//Location of the directory (Test Directory) (the path) taken from the cmd line (second arg)
		File dirLocationTest = new File(args[1]);

		// Listing of the directory (should contain 2 subdirectories: ham/ and spam/)
		File[] dirListingTest = new File[0];

		// Check if the cmd line arg is a directory and list it
		if (dirLocationTest.isDirectory()) {
			dirListingTest = dirLocationTest.listFiles();
		}
		else {
			System.out.println("Error: cmd line arg not a directory.\n");
		    Runtime.getRuntime().exit(0);
		}

		// Listings of the two subdirectories (ham/ and spam/)
		File[] filesHamTest = new File[0];
		File[] filesSpamTest = new File[0];

		// Check that there are 2 subdirectories
		if (dirListingTest.length == 2) {
			filesHamTest = dirListingTest[0].listFiles();
			filesSpamTest= dirListingTest[1].listFiles();
		}
		else {
			System.out.println("Error: specified directory does not contain two subdirectories.\n");
		    Runtime.getRuntime().exit(0);
		}

		
		//get total number of words in the Ham and Spam and total words in vocabulary.
		for (Enumeration e = vocab.keys(); e.hasMoreElements(); ) {
			String wordTemp;
			wordTemp = (String)e.nextElement();
			freq  = (FrequencyPair)vocab.get(wordTemp);
			totalWordsInHam = totalWordsInHam + freq.freqHam;
			totalWordsInSpam = totalWordsInSpam + freq.freqSpam;
			totalWordsInVoc = totalWordsInVoc + 1;
		}
		
		//Initialize pHam and pSpam for the Ham Directory
		//Calculate probability of Ham and Spam with all emails		
		pHam = Math.log10((double)filesHam.length/(filesHam.length + filesSpam.length));
		pSpam = Math.log10((double)filesSpam.length/(filesHam.length + filesSpam.length));
				
		//Read the documents and test 
		// Ham Directory
		System.out.println("\nDirectory -> Test\\Ham");
		System.out.println("**********************");
		for (int i = 0; i < filesHamTest.length; i++) {        //Loop through all files in Ham Directory
			FileInputStream i_s = new FileInputStream(filesHamTest[i]);
			BufferedReader in = new BufferedReader(new InputStreamReader(i_s));
	        String line;
			String word;
			//double pHam_email = 0;     //probability that email is Ham
			//double pSpam_email = 0;    //probability that email is Spam

			// Loop through all lines in Files
        	while ((line = in.readLine()) != null) {            // read a line
				StringTokenizer st = new StringTokenizer(line);	// parse it into words
				while (st.hasMoreTokens()) 	{
					word = st.nextToken();
					
					String newWord = fixWord(word);
					word = newWord;
										
					if( word.length() >=4 )	 // only if it is greater than or equal to 4
						if (vocab.containsKey(word))    //only if vocabulary contains word
						{
							pHam = pHam + wordProb(word,"Ham",vocab,totalWordsInHam,totalWordsInVoc);
							pSpam = pSpam + wordProb(word,"Spam",vocab,totalWordsInSpam,totalWordsInVoc);
						}
																
				} //end while for words
			} // end while for lines
            
        	System.out.print("File: " + filesHamTest[i].getName() + "->");
        	if (pHam > pSpam)
        	{
        		System.out.println("Ham");
        		countCorrect = countCorrect + 1;
        	}
        	else
        		System.out.println("Spam");
                	
            in.close();
            countTotal = countTotal + 1;
          
		} // end for loop for files

		//Re-initialize the values of pHam and PSpam for the Spam Directory
		//Calculate probability of Ham and Spam with all emails		
		pHam = Math.log10((double)filesHam.length/(filesHam.length + filesSpam.length));
		pSpam = Math.log10((double)filesSpam.length/(filesHam.length + filesSpam.length));

		//Read the documents and test 
		//Spam Directory
		System.out.println("\nDirectory -> Test\\Spam");
		System.out.println("***********************");
		for (int i = 0; i < filesSpamTest.length; i++) {        //Loop through all files in Spam Directory
			FileInputStream i_s = new FileInputStream(filesSpamTest[i]);
			BufferedReader in = new BufferedReader(new InputStreamReader(i_s));
	        String line;
			String word;
			//double pHam_email = 0;		//probability that email is Ham
			//double pSpam_email = 0;		//probability that email is Spam

			// Loop through all lines in Files
        	while ((line = in.readLine()) != null) {            // read a line
				StringTokenizer st = new StringTokenizer(line);	// parse it into words
				while (st.hasMoreTokens()) 	{
					word = st.nextToken();
					
					String newWord = fixWord(word);
					word = newWord;
					if( word.length() >=4)	 // only if it is greater than or equal to 4
						if (vocab.containsKey(word))    //only if vocabulary contains word
						{
							pHam = pHam + wordProb(word,"Ham",vocab,totalWordsInHam,totalWordsInVoc);
							pSpam = pSpam + wordProb(word,"Spam",vocab,totalWordsInSpam,totalWordsInVoc);
						}
																
				} //end while for words
			} // end while for lines
        	
        	System.out.print("File: " + filesSpamTest[i].getName() + "->");  //output to screen whether ham or spam
        	if (pHam > pSpam)
        		System.out.println("Ham");
        	else
        	{
        		System.out.println("Spam");
        		countCorrect = countCorrect + 1;
        	}
        
        	in.close();
        	countTotal = countTotal + 1;
            
		} // end for loop for files

		double accuracy = ((double)countCorrect/countTotal)*100;
		System.out.println("\nAccuracy ->" + accuracy);
		
		
	} // end main()

		
	// procedure to remove garbage from the word i.e non-characters(45$%&.,!) and convert all to lowercase
	public static String fixWord(String word)
    {
		String temp = new String();
				
		for( int i=0; i < word.length() ; i++)
		{
			 if (word.codePointAt(i) >= 96 && word.codePointAt(i) <= 122)   // if a character and lower case OK.
				 temp = temp + word.charAt(i);
			 else
				 if (word.codePointAt(i) >= 65 && word.codePointAt(i) <= 90)   // if a character and Uppercase.
					 temp = temp + word.charAt(i);
		}		 
			
		return temp.toLowerCase();
		
    } // end fixWord()
	
 
//	 procedure to calculate smoothed word probablilty
	public static double wordProb(String word, String category, Hashtable<String, FrequencyPair> vocab, int totalWordsInCat, int totalWordsInVoc )
    {
		int wordInCat = 0;
		FrequencyPair freq = new FrequencyPair();
		double numerator;
		double denominator;
				
		// Get number of times word appears in the category
		if (vocab.containsKey(word))                  //if word in vocabulary		
			freq = (FrequencyPair)vocab.get(word);    
				
		if (category.contentEquals("Ham"))           //get frequency of category
			wordInCat = freq.freqHam;
		else
			wordInCat = freq.freqSpam;
		
		numerator = wordInCat+0.5;
		denominator = totalWordsInCat + (0.5 * totalWordsInVoc);
		
					
		return Math.log10(numerator/denominator);  //return probability in log format
		
    } // end wordProb()
	
	

} //end class NaiveBayesClassifier
