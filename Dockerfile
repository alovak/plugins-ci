FROM app

RUN echo "<?php phpinfo(); ?>" > index.php

CMD ["supervisord", "-n"]
