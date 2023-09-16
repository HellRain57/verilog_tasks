<h1> Verilog tasks </h1>

<p>The time diagram for the first task is available <a href="https://drive.google.com/file/d/1QhaLHta_GE7qajl5kX2cS-9S9BGtue-y/view?usp=sharing">here</a> </p>
<p>The time diagram for the second  task is available <a href="https://drive.google.com/file/d/1okcoAW8HYwaPsol33X4XAOCUcQiVpx2r/view?usp=sharing">here</a> </p>

<p>Only the code of the main blocks is presented in the github. You can download the full projects (<a href="https://drive.google.com/drive/folders/1ezC6gDup1a9Km8jlPa5ZCEqKfY-67YKR?usp=sharing">task 1</a> and <a href="https://drive.google.com/drive/folders/1mDfafhE7lRg-_OL5M7mfTR3ijuxgfRd9?usp=sharing">task 2</a>)</p>

<p>For a better understanding, I have drawn a small <a href="https://drive.google.com/file/d/1hTQMt68fT77qOWTZUYJiA4dbU6_VFnOY/view?usp=sharing">functional diagram</a> </p>
<p>I also added EN signals so that you can understand where the data packet starts. the meaning of the work is as follows - two DS start at different times, and the SYNC module saves the received values. After both DS set the VALID signal to one, the SYNC module will output the saved data. At the same time, DS will not work at this time, since SYNC did not give them a READY signal. Since FIFO cannot be used, I used RAM blocks to save data</p>
