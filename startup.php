<?php declare(strict_types=1);

echo "Running demo cli script." . PHP_EOL;

while (true) {
    if (rand(0, 10) == 1) {
        break;
    }

    usleep((int) ceil(rand(0, 10) * 100000));

    echo ".";
}

echo PHP_EOL . "Finished." . PHP_EOL;
