<?php

namespace App\Actions\Qlify PlatformTask;

use App\Data\Qlify PlatformTaskArgs;
use App\Jobs\Qlify PlatformTask;
use Spatie\Activitylog\Models\Activity;

/**
 * The initial step to run a `Qlify PlatformTask`: a remote SSH process
 * with monitoring/tracking/trace feature. Such thing is made
 * possible using an Activity model and some attributes.
 */
class PrepareQlify PlatformTask
{
    protected Activity $activity;

    protected Qlify PlatformTaskArgs $remoteProcessArgs;

    public function __construct(Qlify PlatformTaskArgs $remoteProcessArgs)
    {
        $this->remoteProcessArgs = $remoteProcessArgs;

        if ($remoteProcessArgs->model) {
            $properties = $remoteProcessArgs->toArray();
            unset($properties['model']);

            $this->activity = activity()
                ->withProperties($properties)
                ->performedOn($remoteProcessArgs->model)
                ->event($remoteProcessArgs->type)
                ->log('[]');
        } else {
            $this->activity = activity()
                ->withProperties($remoteProcessArgs->toArray())
                ->event($remoteProcessArgs->type)
                ->log('[]');
        }
    }

    public function __invoke(): Activity
    {
        $job = new Qlify PlatformTask(
            activity: $this->activity,
            ignore_errors: $this->remoteProcessArgs->ignore_errors,
            call_event_on_finish: $this->remoteProcessArgs->call_event_on_finish,
            call_event_data: $this->remoteProcessArgs->call_event_data,
        );
        dispatch($job);
        $this->activity->refresh();

        return $this->activity;
    }
}
