# GenderDetect

Simple API for detecting gender by first name.

API created based on brilliant datasets by [mbejda](https://gist.github.com/mbejda):

- [Black-Female-Names.csv](https://gist.github.com/mbejda/9dc89056005a689a6456)
- [Black-Male-Names.csv](https://gist.github.com/mbejda/61eb488cec271086632d)
- [White-Male-Names.csv](https://gist.github.com/mbejda/6c2293ba3333b7e76269)
- [White-Female-Names.csv](https://gist.github.com/mbejda/26ad0574eda7fca78573)
- [Hispanic-Male-Names.csv](https://gist.github.com/mbejda/21fbbfe24efd2a114800)
- [Hispanic-Female-Names.csv](https://gist.github.com/mbejda/1e77ee4ad268916142a6)
- [Indian-Male-Names.csv](https://gist.github.com/mbejda/7f86ca901fe41bc14a63)
- [Indian-Female-Names.csv](https://gist.github.com/mbejda/9b93c7545c9dd93060bd)

More datasets are here: http://mbejda.github.io

#### Demo:
https://gender-detect-ex.herokuapp.com/detect?name=christina

##### Response like:
```
{"gender":"female","name":"christina","probability":1.0}
```

#### Installation

```
$ git clone https://github.com/alexfilatov/gender_detect.git
$ cd gender_detect
$ iex -S mix
```

Now you have it running on your http://localhost:4000 and you can make requests:

```
http://localhost:4000/detect?name=christina
```


#### Contributing is sexy

- Fork the repo on GitHub
- Clone the project to your own machine
- Commit changes to your own branch
- Push your work back up to your fork
- Submit a Pull request so that we can review your changes
