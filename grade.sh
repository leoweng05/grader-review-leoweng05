rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

if [[ -f student-submission/ListExamples.java ]]
then 
    cp student-submission/ListExamples.java grading-area/
    cp TestListExamples.java grading-area/
    cp -r lib grading-area/
else
    echo 'Missing ListExamples.java, did you forget or misname the file?'
    exit 1
fi

cd grading-area/

CPATH='.;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar'

javac -cp $CPATH *.java
if [[ $? -ne 0 ]]
then
    echo "Program failed to compile"
    exit 1
fi
# echo $(java -cp $CPATH org.junit.runner.JUnitCore TestListExamples)
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

if [[ -n $(grep "OK" junit-output.txt) ]]
then 
    echo "Congrats you passed everything!"
    NUMTESTS= grep "test" junit-output.txt | awk '{print substr($0, 5, 1)}'
    NUMTESTS+=" tests passed"
    echo $NUMTESTS

    exit 0 
fi

echo $(grep "Tests run" junit-output.txt)