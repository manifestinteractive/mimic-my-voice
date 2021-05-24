![Logo](img/mycroft-logo.png "Logo")

**[↤ Developer Overview](../README.md#developer-overview)**

`mimic studio`
---

> Launch Mimic Recording Studio

Quickly get the Mimic Recording Studio up and running via Docker using the following command:

```bash
mimic studio
```

Using Mimic Recording Studio
---

![Audio](img/audio.png "Audio")

### Recording Tips

Creating a TTS Voice requires an achievable but significant effort.  There are over 30,000 total phrases, and the more you record, the better TTS Voice you can make. You will need to record a minimum of 15,000 - 20,000 phrases to create a decent TTS Voice.

To get the best recordings, you need to be clean and consistent.

#### Follow These Recommendations:

- [X] Record in a quiet environment with noise-dampening material if possible.
- [X] Speak at a consistent volume and speed. Rushing through the phrases will only result in a lower quality voice.
- [X] Use a quality microphone in a consistent location to obtain consistent results.
- [X] Record a maximum of 4 hours a day, taking a break every half hour to avoid vocal fatigue
- [X] It is vital to run frequent backups using the `mimic backup` command.


Time Management
---

To put the amount of time creating a quality TTS Voice will take into perspective, let's do some math:

* Each recording can take anywhere from 1 to 3 minutes
* 30,000 phrases can be recorded, but a minimum of 15,000 phrases are needed
* You are spending no more than 4 hours a day recording

Phrases | 1 Minute  | 3 minutes
--------|-----------|-----------
15,000  | 62.5 Days | 187.5 Days
20,000  | 83 Days   | 250 Days
25,000  | 104 Days  | 312.5 Days
30,000  | 125 Days  | 375 Days
