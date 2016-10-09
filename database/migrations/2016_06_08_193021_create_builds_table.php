<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateBuildsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('osu_builds', function (Blueprint $table) {
            $table->mediumInteger('build_id')->unsigned();
            $table->string('version', 40)->nullable();
            $table->binary('hash', 16)->nullable();
            $table->binary('last_hash', 16)->nullable();

            $table->timestamp('date');

            $table->tinyInteger('allow_ranking')->default(1);
            $table->tinyInteger('allow_bancho')->default(1);
            $table->tinyInteger('test_build')->default(0);
            
            $table->string('comments', 200)->nullable();
            $table->mediumInteger('users')->unsigned()->default(0);
            $table->tinyInteger('stream_id')->unsigned()->nullable();


            //$table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('osu_builds');
    }
}
