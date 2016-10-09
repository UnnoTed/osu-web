<?php

use Illuminate\Database\Seeder;
use App\Models\Changelog;
use Faker\Factory as Faker;

class ChangelogSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $day = 0;
        $faker = Faker::create();
        $streams = ['Stable', 'Stable Fallback', 'Beta', 'Cutting Edge', 'Lazer'];
        $stream_users = [
            [9000, 16000],
            [5500, 8000],
            [3500, 4200],
            [1200, 2400],
            [100, 600],
        ];

        for ($i = 0; $i < 20; $i++)
        {
            foreach ($streams as $key => $value)
            {
                $day++;

                $version = $faker->date('Ymd', '- ' . $day . ' days');
                $users = rand($stream_users[$key][0], // min
                              $stream_users[$key][1]); // max

                // changelog
                $id = DB::table('osu_changelog')->insertGetId([
                    'user_id' => rand(1, 2),
                    'prefix' => '*',
                    'category' => '',

                    'message' => $faker->realText(50, 1),
                    'checksum' => md5(str_random(10)),
                    'date' => $version,

                    'private' => 0,
                    'major' => '',
                    'tweet' => '',

                    'build' => $version,
                    'thread_id' => '',
                    'url' => '',

                    'stream_id' => $key,
                ]);

                // builds
                DB::table('osu_builds')->insert([
                    'build_id' => $id,
                    'version' => $version,
                    'hash' => md5(str_random(10)),

                    'last_hash' => md5(str_random(10)),
                    'date' => $version,
                    'allow_ranking' => 1,

                    'allow_bancho' => 1,
                    'test_build' => false,
                    'comments' => $faker->realText(20, 1),

                    'users' => $users,
                    'stream_id' => $key,
                ]);
            }
        }
    }
}
