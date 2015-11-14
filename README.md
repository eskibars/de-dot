# de-dot
This attempts to reindex elasticsearch data from 1 location to another,
converting field names with dots to underscores

# Reason
In Elasticsearch 2.0 field names with dots are no longer allowed.  Overall, this is a good thing.
These fields caused lots of problems:
1. [Logstash](https://discuss.elastic.co/t/please-read-upgrading-logstash-and-elasticsearch-to-2-0/33791)
2. [Kibana](https://github.com/elastic/kibana/issues/3540)
3. [Core Elasticsearch](https://github.com/elastic/elasticsearch/issues/11337)

# Running
Before you run this, make sure to set up your new index with proper mappings.
Your old "." fields won't exist anymore.  You'll need to create the _ ones in their stead with the proper mappings.

# License
-------
    This software is licensed under the Apache 2 license, quoted below.

    Copyright 2009-2015 Elasticsearch <https://www.elastic.co>

    Licensed under the Apache License, Version 2.0 (the "License"); you may not
    use this file except in compliance with the License. You may obtain a copy of
    the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
    License for the specific language governing permissions and limitations under
    the License.
