Music Library
===

Forked from the original project at 
https://gist.github.com/bendilley/20dece4cff6bb4fa5eae74f985b13e7d

I have restructured the project to use RSpec. This separates out the
benchmarking and logging code from implementation, and allows testing of 
expectations that the new implementation provides the same results
as the original. We show that the new implementation is not just faster, 
that it's correct.

To allow faster testing of new implementations, the code will generate a
Marshal dump of the results from the original implementation the first
time it is run. For subsequent runs this is loaded from file 
rather than rerunning the slow implementation.

Similarly, on the first run the original CSV file is downloaded from the 
forked Gist. It is stored locally and the local file is used for test
testing.

On each run, when tests pass, the file `perf.txt` has an entry written 
to it. This contains current time, hostname, and benchmark output. 
These results are committed to git at the same time as code, allowing 
changes and performance timings to be easily aligned for review.

Running Tests
--

Check `gem list rspec` returns a valid installation.

If not, `gem install rspec` prior to running the first time. 

To run tests, simply run `rspec` in the root directory of the project.

Run `cat perf.txt` to see the benchmark timings

Files
--

```
    ./perf.txt # benchmark timings
    ./results.o # original implementation Marshal dump
    ./the_music.csv # downloaded CSV of albums
    lib/music_library.rb # the source code for the new implementation
    spec/music_library_spec.rb # test examples for benchmark and compare
```
