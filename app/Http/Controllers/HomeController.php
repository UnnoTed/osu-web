<?php

/**
 *    Copyright 2015 ppy Pty. Ltd.
 *
 *    This file is part of osu!web. osu!web is distributed with the hope of
 *    attracting more community contributions to the core ecosystem of osu!.
 *
 *    osu!web is free software: you can redistribute it and/or modify
 *    it under the terms of the Affero GNU General Public License version 3
 *    as published by the Free Software Foundation.
 *
 *    osu!web is distributed WITHOUT ANY WARRANTY; without even the implied
 *    warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *    See the GNU Affero General Public License for more details.
 *
 *    You should have received a copy of the GNU Affero General Public License
 *    along with osu!web.  If not, see <http://www.gnu.org/licenses/>.
 */
namespace App\Http\Controllers;

use App\Models\Changelog;
use App\Models\Builds;
use View;

class HomeController extends Controller
{
    protected $section = 'home';

    public function getNews()
    {
        return view('home.news');
    }

    public function getChangelog()
    {
        $data = [];

        // id -> name
        $streams = [
            0 => [
                'name' => 'Stable',
                'color' => 'blue',
                'size' => 'big',
            ],
            1 => [
                'name' => 'Stable Fallback',
                'color' => 'green',
            ],
            2 => [
                'name' => 'Beta',
                'color' => 'yellow',
            ],
            3 => [
                'name' => 'Cutting Edge',
                'color' => 'yellow',
            ],
            4 => [
                'name' => 'Lazer',
                'color' => 'red',
            ],
        ];

        foreach ($streams as $id => $stream) {
            $build = Builds::version($id);

            $latest = 0;
            if(!isset($build[$latest])) continue;

            $stream['logs'] = Changelog::stream($id);
            $stream['version'] = $build[$latest]['version'];
            $stream['users'] = $build[$latest]['users'];
            array_push($data, $stream);
        }

        return view('home.changelog')->with('data', ['changelog' => $data]);
        /*->with('data', [
            'changelog' => [
                // Stable - blue - big
                [
                    'version' => '20160504.1',
                    'chart' => [
                        [
                            'date' => '23-2-2016 10:40:18', 
                            'users' => 9001,
                        ],

                        [
                            'date' => '24-2-2016 10:40:18',
                            'users' => 8987,
                        ],

                        [
                            'date' => '25-2-2016 10:40:18',
                            'users' => 9051,
                        ],

                        [
                            'date' => '26-2-2016 10:40:18',
                            'users' => 9788,
                        ],

                        [
                            'date' => '27-2-2016 10:40:18',
                            'users' => 9054,
                        ],

                        [
                            'date' => '28-2-2016 10:40:18',
                            'users' => 9135,
                        ],

                        [
                            'date' => '29-2-2016 10:40:18',
                            'users' => 9001,
                        ],
                    ],
                    'color' => 'blue',
                    'users' => '9001',
                    'size' => 'big',
                    'name' => 'Stable',
                    'logs' => [
                        '23-2-2016 10:40:18' => [
                            'b20140901.1' => [
                                [
                                    'author' => 'TheVileOne',
                                    'type' => 'fix',
                                    'text' => 'Have the updater share a mutex GUID with osu!. They should never be running at the same point in time.',
                                ],

                                [
                                    'author' => 'peppy',
                                    'type' => 'add',
                                    'text' => 'Add sane script execution time limits to avoid hanging php processes.',
                                ],

                                [
                                    'author' => 'peppy',
                                    'type' => 'fix',
                                    'text' => 'Force an external update if too many update failures are detecTed.',
                                ],

                                [
                                    'author' => 'peppy',
                                    'type' => 'fix',
                                    'text' => 'Provide a better error message on trying to download a corrupt beatmap.',
                                ],
                            ],

                            'b20140825' => [
                                [
                                    'author' => 'peppy',
                                    'type' => 'add',
                                    'text' => 'Added the unadded.',
                                ],

                                [
                                    'author' => 'peppy',
                                    'type' => 'fix',
                                    'text' => 'Fixed the unfixable.',
                                ],
                            ],
                        ],
                    ],
                ],

                // Stable Fallback - green
                [
                    'version' => '20160422',
                    'chart' => [
                        [
                            'date' => '23-2-2016 10:40:18', 
                            'users' => 6054,
                        ],

                        [
                            'date' => '24-2-2016 10:40:18',
                            'users' => 6354,
                        ],

                        [
                            'date' => '25-2-2016 10:40:18',
                            'users' => 6051,
                        ],

                        [
                            'date' => '26-2-2016 10:40:18',
                            'users' => 6545,
                        ],

                        [
                            'date' => '27-2-2016 10:40:18',
                            'users' => 6011,
                        ],

                        [
                            'date' => '28-2-2016 10:40:18',
                            'users' => 6345,
                        ],

                        [
                            'date' => '29-2-2016 10:40:18',
                            'users' => 6464,
                        ],
                    ],
                    'color' => 'green',
                    'users' => '9,001',
                    'name' => 'Stable Fallback',
                    'logs' => [
                        '23-2-2016 10:40:18' => [
                            'sf20140901.1' => [
                                [
                                    'author' => 'aa',
                                    'type' => 'fix',
                                    'text' => 'bbbbb',
                                ],

                                [
                                    'author' => 'ccccc',
                                    'type' => 'add',
                                    'text' => 'dddddddd',
                                ],
                            ],

                            'sf20140825' => [
                                [
                                    'author' => 'peppy',
                                    'type' => 'add',
                                    'text' => 'Added the unadded.',
                                ],

                                [
                                    'author' => 'peppy',
                                    'type' => 'fix',
                                    'text' => 'Fixed the unfixable.',
                                ],
                            ],
                        ],
                    ],
                ],

                // Beta - yellow
                [
                    'version' => '20160403',
                    'chart' => [
                        [
                            'date' => '23-2-2016 10:40:18', 
                            'users' => 4354,
                        ],

                        [
                            'date' => '24-2-2016 10:40:18',
                            'users' => 4001,
                        ],

                        [
                            'date' => '25-2-2016 10:40:18',
                            'users' => 4545,
                        ],

                        [
                            'date' => '26-2-2016 10:40:18',
                            'users' => 4321,
                        ],

                        [
                            'date' => '27-2-2016 10:40:18',
                            'users' => 4215,
                        ],

                        [
                            'date' => '28-2-2016 10:40:18',
                            'users' => 4444,
                        ],

                        [
                            'date' => '29-2-2016 10:40:18',
                            'users' => 4325,
                        ],
                    ],
                    'color' => 'yellow',
                    'users' => '3678',
                    'name' => 'Beta',
                    'logs' => [
                        '23-2-2016 10:40:18' => [
                            'b20140901.1' => [
                                [
                                    'author' => 'a21321a',
                                    'type' => 'fix',
                                    'text' => 'b534123b12',
                                ],

                                [
                                    'author' => 'c2321c',
                                    'type' => 'add',
                                    'text' => 'dbq43214',
                                ],
                            ],

                            'b20140825' => [
                                [
                                    'author' => 'peppy',
                                    'type' => 'add',
                                    'text' => 'Ayydded',
                                ],

                                [
                                    'author' => 'peppy',
                                    'type' => 'fix',
                                    'text' => 'Fixesssssssssss',
                                ],
                            ],
                        ],
                    ],
                ],

                // Cutting Edge - yellow
                [
                    'version' => '20160504.1',
                    'chart' => [
                        [
                            'date' => '23-2-2016 10:40:18', 
                            'users' => 2000,
                        ],

                        [
                            'date' => '24-2-2016 10:40:18',
                            'users' => 2076,
                        ],

                        [
                            'date' => '25-2-2016 10:40:18',
                            'users' => 2079,
                        ],

                        [
                            'date' => '26-2-2016 10:40:18',
                            'users' => 2045,
                        ],

                        [
                            'date' => '27-2-2016 10:40:18',
                            'users' => 2087,
                        ],

                        [
                            'date' => '28-2-2016 10:40:18',
                            'users' => 2078,
                        ],

                        [
                            'date' => '29-2-2016 10:40:18',
                            'users' => 2044,
                        ],
                    ],
                    'color' => 'yellow',
                    'users' => '2009',
                    'name' => 'Cutting Edge',
                    'logs' => [
                        '23-2-2016 10:40:18' => [
                            'ce20140901.1' => [
                                [
                                    'author' => 'fdasdsdas',
                                    'type' => 'fix',
                                    'text' => '45345345324612312',
                                ],

                                [
                                    'author' => 'dadas',
                                    'type' => 'add',
                                    'text' => 'ddd43243ddddd',
                                ],
                            ],

                            'ce20140825' => [
                                [
                                    'author' => 'peppy',
                                    'type' => 'add',
                                    'text' => 'Added the dsadsadaweawdasd.',
                                ],

                                [
                                    'author' => 'peppy',
                                    'type' => 'fix',
                                    'text' => 'Fixed the ewaeawe2431313123.',
                                ],
                            ],
                        ],
                    ],
                ],

                // Lazer - red
                [
                    'version' => '20160504.1',
                    'chart' => [
                        [
                            'date' => '23-2-2016 10:40:18', 
                            'users' => 123,
                        ],

                        [
                            'date' => '24-2-2016 10:40:18',
                            'users' => 213,
                        ],

                        [
                            'date' => '25-2-2016 10:40:18',
                            'users' => 134,
                        ],

                        [
                            'date' => '26-2-2016 10:40:18',
                            'users' => 354,
                        ],

                        [
                            'date' => '27-2-2016 10:40:18',
                            'users' => 584,
                        ],

                        [
                            'date' => '28-2-2016 10:40:18',
                            'users' => 489,
                        ],

                        [
                            'date' => '29-2-2016 10:40:18',
                            'users' => 687,
                        ],
                    ],
                    'color' => 'red',
                    'users' => '450',
                    'name' => 'Lazer',
                    'logs' => [
                        '23-2-2016 10:40:18' => [
                            'l20140901.1' => [
                                [
                                    'author' => 'aayy',
                                    'type' => 'fix',
                                    'text' => 'bbbbb5321',
                                ],

                                [
                                    'author' => 'ccccca',
                                    'type' => 'add',
                                    'text' => 'dddddddd123',
                                ],
                            ],

                            'l20140825' => [
                                [
                                    'author' => 'the big kahuna',
                                    'type' => 'add',
                                    'text' => 'Added something.',
                                ],

                                [
                                    'author' => 'peppy',
                                    'type' => 'fix',
                                    'text' => 'Fixed the unfixed.',
                                ],
                            ],
                        ],
                    ],
                ],
            ],
        ]);*/
    }

    public function getDownload()
    {
        return view('home.download');
    }

    public function getIcons()
    {
        return view('home.icons')
        ->with('icons', [
            'osu-o', 'mania-o', 'fruits-o', 'taiko-o',
            'osu', 'mania', 'fruits', 'taiko',
            'bat', 'bubble', 'hourglass', 'dice', 'bomb', 'osu-spinner', 'net', 'mod-headphones',
            'easy-osu', 'normal-osu', 'hard-osu', 'insane-osu', 'expert-osu',
            'easy-taiko', 'normal-taiko', 'hard-taiko', 'insane-taiko', 'expert-taiko',
            'easy-fruits', 'normal-fruits', 'hard-fruits', 'insane-fruits', 'expert-fruits',
            'easy-mania', 'normal-mania', 'hard-mania', 'insane-mania', 'expert-mania',
        ]);
    }

    public function supportTheGame()
    {
        return view('home.support-the-game')
        ->with('data', [
            // why support's blocks
            'blocks' => [
                // localization's name => icon
                'dev' => 'user',
                'time' => 'clock-o',
                'ads' => 'thumbs-up',
                'goodies' => 'star',
            ],

            // supporter's perks
            'perks' => [
                // localization's name => icon
                'osu_direct' => 'search',
                'auto_downloads' => 'cloud-download',
                'upload_more' => 'cloud-upload',
                'early_access' => 'flask',
                'customisation' => 'picture-o',
                'beatmap_filters' => 'filter',
                'yellow_fellow' => 'fire',
                'speedy_downloads' => 'dashboard',
                'change_username' => 'magic',
                'skinnables' => 'paint-brush',
                'feature_votes' => 'thumbs-up',
                'sort_options' => 'trophy',
                'feel_special' => 'heart',
                'more_to_come' => 'gift',
            ],
        ]);
    }
}
