## **How to ask questions**



In order to reduce communication costs, to help you solve the problem directly, please read the wiki before asking to help you ask better questions, solve problems more quickly and efficiently.

I hope the 80% of the time spent solving problems, rather than a question and answer on the Q & A, is really a waste of time. If we are wasting people's time, how others take the time to help you solve the problem? With people easily, your own convenience.

If you are a developer, ready to watch SRS code, ready to change something, then the following "Developer Notes" is what you want to see in detail.

If you are a user, simply run the SRS, or need to find a bug report bug, then see "User Information" just fine.


## **Community Code**



Some basic rules:

Do not ask me a single question asked in the group. The reason is simple: First, many Azeri population, both alone and asked me if I was going to die. Second, most of the questions are repetitive, they might ask someone else in the group knows. Third, I hope SRS form communities, communities can help each other. Of course, if there are special circumstances may be an exception.
Do not ask open-ended questions, ask closed questions. This is all a question of principle, for example, do not ask SRS okay? What RTMP is? To ask specific questions: RTMP is extended timestamp, the head of the c3 will send it?
Before asking questions over again wiki, basically all have the answer your question in the wiki, does it have to find someone to help you wiki link it?


## **Developers Conditions**


SRS group and mailing list, not the teacher's blackboard and students raise the question, 80% of the questions do not deserve answers, as 80% of the problems are "looking at the code." Do not show their childish and lazy, to get their own problems, why should someone else do it?

Do not ask abstract questions, such as how to achieve SRS RTMP? How the HLS stream? How to handle concurrency? How to thread synchronization?
Asked very specific questions, such as how to deal with the timestamp ts do not ask, but asking: xxx first line of code to calculate pts = dts + cts, cts whether the timestamp rtmp package? Of course, this problem can be understood under the debugger.
Do not generalities to ask questions, read the README, read WIKI, own debugging code, and then ask questions. Only allow the developer to ask specific questions.

## **Notice to users**


Asked what needs to be done before? Ensure that others have encountered similar problems, or wiki already explained, do not mention this problem.

Here are some basic questions:

How to compile: Reference Build
SRS what hardware environment: Reference Build
SRS what software environment: Reference Build
Why not see the stream? May be a firewall issue, refer Build
How to build a cluster: Reference Cluster
How to measure the performance of SRS: Reference Performance
SRS authorization is MIT? Reference License
How to see the SRS DEMO? Reference Readme
Step by step how to compile the SRS DEMO? Reference Readme
Who is the lead author of the SRS? Reference Readme
What is the structure of SRS? Reference Readme
What SRS function, which is the development of? Reference Readme
SRS releases what? Reference Readme
SRS and Nginx-Rtmp/CRtmpServer/Red5/Wowza/FMS/Helix compared advantage? Reference Readme
SRS developers every day what to do? Reference Reaame
If the above is not what you want to raise this issue, see Wiki , if all rummaged Wiki, or not, then refer to the following question asked a question it.

## **Sample questions**


When you ask questions, you need to collect the following important information:

Problem Description: first description of the problem.
Operating Environment: Operating System (median, version), how many servers, the server IP and other information
Network Architecture: How to push encoder flow SRS, SRS how to distribute to the player.
SRS version: master branch is the latest code, or a version. SRS execute command to get the version: . / objs / srs-V
Encoder plug-flow mode: Do not say that with ffmpeg plug flow, to illustrate specific ways.
SRS configuration file: Please do not say that I was a reference which wiki, because you can not remember on the wiki, paste the contents of the configuration file directly to it.
SRS startup script: Please do not refer to the README way to start, give a specific start-up mode.
Client playback mode: Do not say a client can not play, it should be described in detail in playback mode, and logs.
SRS server log: server logs sent to the SRS, can be configured together to make a package.

For practical example:

<pre>When submitting bug, or ask questions, explain the following:
* System: What operating system? 32 or 64? Compiler version number?
* Encoder: What encoder? What version? What encoding parameters? What is the current address?
* Server: Using SRS what version? What configuration? What logs are?
* Client: what client? What version?
* Problems and steps to reproduce: What is the question? What are the steps to reproduce?</pre>

This problem will soon be able to get the investigation, developers can follow the steps to reproduce reproduction.